{ lib
, stdenv
, buildPythonPackage
, chromium
, ffmpeg
, firefox
, git
, greenlet
, jq
, nodejs
, fetchFromGitHub
, fetchurl
, makeFontsConf
, makeWrapper
, pyee
, python
, pythonOlder
, runCommand
, setuptools-scm
, unzip
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  driverVersion = "1.27.1";

  driver = let
    suffix = {
      x86_64-linux = "linux";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "mac";
      aarch64-darwin = "mac-arm64";
    }.${system} or throwSystem;
    filename = "playwright-${driverVersion}-${suffix}.zip";
  in stdenv.mkDerivation {
    pname = "playwright-driver";
    version = driverVersion;

    src = fetchurl {
      url = "https://playwright.azureedge.net/builds/driver/${filename}";
      sha256 = {
        x86_64-linux = "0x71b4kb8hlyacixipgfbgjgrbmhckxpbmrs2xk8iis7n5kg7539";
        aarch64-linux = "125lih7g2gj91k7j196wy5a5746wyfr8idj3ng369yh5wl7lfcfv";
        x86_64-darwin = "0z2kww4iby1izkwn6z2ai94y87bkjvwak8awdmjm8sgg00pa9l1a";
        aarch64-darwin = "0qajh4ac5lr1sznb2c471r5c5g2r0dk2pyqz8vhvnbk36r524h1h";
      }.${system} or throwSystem;
    };

    sourceRoot = ".";

    nativeBuildInputs = [ unzip ];

    postPatch = ''
      # Use Nix's NodeJS instead of the bundled one.
      substituteInPlace playwright.sh --replace '"$SCRIPT_PATH/node"' '"${nodejs}/bin/node"'
      rm node

      # Hard-code the script path to $out directory to avoid a dependency on coreutils
      substituteInPlace playwright.sh \
        --replace 'SCRIPT_PATH="$(cd "$(dirname "$0")" ; pwd -P)"' "SCRIPT_PATH=$out"

      patchShebangs playwright.sh package/bin/*.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mv playwright.sh $out/bin/playwright
      mv package $out/

      runHook postInstall
    '';

    passthru = {
      inherit filename;
    };
  };

  browsers-mac = stdenv.mkDerivation {
    pname = "playwright-browsers";
    version = driverVersion;

    src = runCommand "playwright-browsers-base" {
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = {
        x86_64-darwin = "0z2kww4iby1izkwn6z2ai94y87bkjvwak8awdmjm8sgg00pa9l1a";
      }.${system} or throwSystem;
    } ''
      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${driver}/bin/playwright install
      rm -r $out/.links
    '';

    installPhase = ''
      mkdir $out
      cp -r * $out/
    '';
  };

  browsers-linux = { withFirefox ? true, withChromium ? true }: let
    fontconfig = makeFontsConf {
      fontDirectories = [];
    };
  in runCommand ("playwright-browsers"
    + lib.optionalString (withFirefox && !withChromium) "-firefox"
    + lib.optionalString (!withFirefox && withChromium) "-chromium")
  {
    nativeBuildInputs = [
      makeWrapper
      jq
    ];
  } (''
    BROWSERS_JSON=${driver}/package/browsers.json
  '' + lib.optionalString withChromium ''
    CHROMIUM_REVISION=$(jq -r '.browsers[] | select(.name == "chromium").revision' $BROWSERS_JSON)
    mkdir -p $out/chromium-$CHROMIUM_REVISION/chrome-linux

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    makeWrapper ${chromium}/bin/chromium $out/chromium-$CHROMIUM_REVISION/chrome-linux/chrome \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set FONTCONFIG_FILE ${fontconfig}
  '' + lib.optionalString withFirefox ''
    FIREFOX_REVISION=$(jq -r '.browsers[] | select(.name == "firefox").revision' $BROWSERS_JSON)
    mkdir -p $out/firefox-$FIREFOX_REVISION/firefox
    ln -s ${firefox}/bin/firefox $out/firefox-$FIREFOX_REVISION/firefox/firefox
  '' + ''
    FFMPEG_REVISION=$(jq -r '.browsers[] | select(.name == "ffmpeg").revision' $BROWSERS_JSON)
    mkdir -p $out/ffmpeg-$FFMPEG_REVISION
    ln -s ${ffmpeg}/bin/ffmpeg $out/ffmpeg-$FFMPEG_REVISION/ffmpeg-linux
  '');
in
buildPythonPackage rec {
  pname = "playwright";
  version = "1.27.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "v${version}";
    sha256 = "sha256-cI/4GdkmTikoP9O0Skh/0jCxxRypRua0231iKcxtBcY=";
  };

  patches = [
    # This patches two things:
    # - The driver location, which is now a static package in the Nix store.
    # - The setup script, which would try to download the driver package from
    #   a CDN and patch wheels so that they include it. We don't want this
    #   we have our own driver build.
    ./driver-location.patch
  ];

  postPatch = ''
    # if setuptools_scm is not listing files via git almost all python files are excluded
    export HOME=$(mktemp -d)
    git init .
    git add -A .
    git config --global user.email "nixpkgs"
    git config --global user.name "nixpkgs"
    git commit -m "workaround setuptools-scm"

    substituteInPlace setup.py \
      --replace "greenlet==1.1.3" "greenlet>=1.1.3" \
      --replace "pyee==8.1.0" "pyee>=8.1.0" \
      --replace "setuptools-scm==7.0.5" "setuptools-scm>=7.0.5" \
      --replace "wheel==0.37.1" "wheel>=0.37.1"

    # Skip trying to download and extract the driver.
    # This is done manually in postInstall instead.
    substituteInPlace setup.py \
      --replace "self._download_and_extract_local_driver(base_wheel_bundles)" ""

    # Set the correct driver path with the help of a patch in patches
    substituteInPlace playwright/_impl/_driver.py \
      --replace "@driver@" "${driver}/bin/playwright"
  '';


  nativeBuildInputs = [ git setuptools-scm ];

  propagatedBuildInputs = [
    greenlet
    pyee
  ];

  postInstall = ''
    ln -s ${driver} $out/${python.sitePackages}/playwright/driver
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # Skip tests because they require network access.
  doCheck = false;

  pythonImportsCheck = [
    "playwright"
  ];

  passthru = rec {
    inherit driver;
    browsers = {
      x86_64-linux = browsers-linux { };
      aarch64-linux = browsers-linux { };
      x86_64-darwin = browsers-mac;
      aarch64-darwin = browsers-mac;
    }.${system} or throwSystem;
    browsers-chromium = browsers-linux { withFirefox = false; };
    browsers-firefox = browsers-linux { withChromium = false; };

    tests = {
      inherit driver browsers;
    };
  };

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick yrd SuperSandro2000 ];
  };
}
