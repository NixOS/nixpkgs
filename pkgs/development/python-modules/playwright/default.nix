{ lib
, stdenv
, buildPythonPackage
, chromium
, ffmpeg
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

  driverVersion = "1.31.1";

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
        x86_64-linux = "1wg49kfs8fflmx8g01bkckbjkghhwy7c44akckjf7dp4lbh1z8fd";
        aarch64-linux = "0f09a0cxqxihy8lmbjzii80jkpf3n5xlvhjpgdkwmrr3wh0nnixj";
        x86_64-darwin = "1zd0dz8jazymcpa1im5yzxb7rwl6wn4xz19lpz83bnpd1njq01b3";
        aarch64-darwin = "0hcn80zm9aki8hzsf1cljzcmi4iaw7fascs8ajj0qcwqkkm4jnw0";
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

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${driver}/bin/playwright install
      rm -r $out/.links

      runHook postInstall
    '';

    meta.platforms = lib.platforms.darwin;
  };

  browsers-linux = {}: let
    fontconfig = makeFontsConf {
      fontDirectories = [];
    };
  in runCommand "playwright-browsers"
  {
    nativeBuildInputs = [
      makeWrapper
      jq
    ];
  } (''
    BROWSERS_JSON=${driver}/package/browsers.json
    CHROMIUM_REVISION=$(jq -r '.browsers[] | select(.name == "chromium").revision' $BROWSERS_JSON)
    mkdir -p $out/chromium-$CHROMIUM_REVISION/chrome-linux

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    makeWrapper ${chromium}/bin/chromium $out/chromium-$CHROMIUM_REVISION/chrome-linux/chrome \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set FONTCONFIG_FILE ${fontconfig}

    FFMPEG_REVISION=$(jq -r '.browsers[] | select(.name == "ffmpeg").revision' $BROWSERS_JSON)
    mkdir -p $out/ffmpeg-$FFMPEG_REVISION
    ln -s ${ffmpeg}/bin/ffmpeg $out/ffmpeg-$FFMPEG_REVISION/ffmpeg-linux
  '');
in
buildPythonPackage rec {
  pname = "playwright";
  version = "1.31.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "v${version}";
    hash = "sha256-zVJiRIJDWmFdMCGK9siewiYgjeeTuOPY1wWxArcZDJg";
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
      --replace "greenlet==2.0.1" "greenlet>=2.0.1" \
      --replace "pyee==8.1.0" "pyee>=8.1.0" \
      --replace "setuptools-scm==7.0.5" "setuptools-scm>=7.0.5" \
      --replace "wheel==0.38.1" "wheel>=0.37.1"

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
    browsers-chromium = browsers-linux { };

    tests = {
      inherit driver browsers;
    };
  };

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick yrd SuperSandro2000 ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
