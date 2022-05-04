{ lib
, stdenv
, autoPatchelfHook
, callPackage
, fetchFromGitHub
, fetchurl
, makeWrapper
, runCommand
, unzip
, git
, nodejs
, jq

# Python dependencies
, python
, buildPythonPackage
, pythonOlder
, autobahn
, greenlet
, objgraph
, pillow
, pixelmatch
, pyee
, pyopenssl
, requests
, service-identity
, setuptools-scm
, setuptools-scm-git-archive
, websockets

# For building the browser bundle
, cacert
, chromium
, ffmpeg
, firefox
, makeFontsConf
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  driverVersion = "1.25.0";

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
        x86_64-linux = "1nah45q9mihzkz2hqx6dwn7ac88vc22m5zspr23hc7dd1q4ll4ys";
        aarch64-linux = "0wg4z2gb2fhvv4c2gjm6ncvbg9bkaavzq76x1bmm4lsnhjz312hp";
        x86_64-darwin = "1nd6ll6dj0aqic3hh65y0br051ckbcap8spqbvzm19g8dn7vgv7m";
        aarch64-darwin = "08qrzahmdhdv8flfjb58m27dqihq8jc4gwix6knc71209a9x8b83";
      }.${system} or throwSystem;
    };
    sourceRoot = ".";

    nativeBuildInputs = [ unzip ];
    buildInputs = [ nodejs ];

    postPatch = ''
      # Use Nix's NodeJS instead of the bundled one.
      substituteInPlace playwright.sh --replace '"$SCRIPT_PATH/node"' '"${nodejs}/bin/node"'
      rm node

      # Hard-code the script path to be our $out directory. The alternative would be to add
      # coreutils to the closure and use realpath like the upstream script does.
      substituteInPlace playwright.sh \
        --replace 'SCRIPT_PATH="$(cd "$(dirname "$0")" ; pwd -P)"' "SCRIPT_PATH=$out"

      patchShebangs playwright.sh package/bin/*.sh
    '';

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/playwright-driver
      mv playwright.sh package $out/share/playwright-driver/
      ln -s $out/share/playwright-driver/playwright.sh $out/bin/playwright

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
        x86_64-darwin = "1nd6ll6dj0aqic3hh65y0br051ckbcap8spqbvzm19g8dn7vgv7m";
      }.${system} or throwSystem;
    } ''
      export PLAYWRIGHT_BROWSERS_PATH=$out
      ${driver}/bin/playwright install
      rm -r $out/.links
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -r * $out/
    '';

    doCheck = false;
  };

  browsers-linux = let
    fontconfig = makeFontsConf {
      fontDirectories = [];
    };
  in runCommand "playwright-browsers" {
    nativeBuildInputs = [
      makeWrapper
      jq
    ];
  } ''
    BROWSERS_JSON=${driver}/share/playwright-driver/package/browsers.json
    CHROMIUM_REVISION=$(jq -r '.browsers[] | select(.name == "chromium").revision' $BROWSERS_JSON)
    FFMPEG_REVISION=$(jq -r '.browsers[] | select(.name == "ffmpeg").revision' $BROWSERS_JSON)
    FIREFOX_REVISION=$(jq -r '.browsers[] | select(.name == "firefox").revision' $BROWSERS_JSON)

    mkdir -p \
      $out/chromium-$CHROMIUM_REVISION/chrome-linux \
      $out/ffmpeg-$FFMPEG_REVISION \
      $out/firefox-$FIREFOX_REVISION

    # See here for the Chrome options:
    # https://github.com/NixOS/nixpkgs/issues/136207#issuecomment-908637738
    makeWrapper ${chromium}/bin/chromium $out/chromium-$CHROMIUM_REVISION/chrome-linux/chrome \
      --set SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set FONTCONFIG_FILE ${fontconfig}

    ln -s ${ffmpeg}/bin/ffmpeg $out/ffmpeg-$FFMPEG_REVISION/ffmpeg-linux

    ln -s ${firefox}/bin/firefox $out/firefox-$FIREFOX_REVISION/firefox
  '';
in
buildPythonPackage rec {
  pname = "playwright";
  version = "1.25.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "v${version}";
    sha256 = "sha256-K9hVTGGqTx3tTjGrwcLQisp3gq/lLJ/Y0GLDZcikSzw=";
    leaveDotGit = true;
  };

  patches = [
    # This patches two things:
    # - The driver location, which is now a static package in the Nix store.
    # - The setup script, which would try to download the driver package from
    #   a CDN and patch wheels so that they include it. We don't want this
    #   we have our own driver build.
    ./driver-location.patch
  ];

  nativeBuildInputs = [ git setuptools-scm ];
  propagatedBuildInputs = [
    autobahn
    greenlet
    objgraph
    pillow
    pixelmatch
    pyee
    pyopenssl
    requests
    service-identity
    websockets
  ];

  postPatch = ''
    # The package seems to work with pyee 9 as well, which is what nixpkgs has packaged.
    substituteInPlace meta.yaml \
      --replace "pyee ==8.1.0" "pyee"
    substituteInPlace setup.py \
      --replace "pyee==8.1.0" "pyee" \
      --replace "websockets==10.1" "websockets"

    # Skip trying to download and extract the driver. We do this manually in
    # postInstall instead. See here:
    # https://github.com/microsoft/playwright-python/blob/v1.25.0/setup.py#L123
    substituteInPlace setup.py \
      --replace "self._download_and_extract_local_driver(base_wheel_bundles)" ""

    # Set the correct driver path (this requires the patch file from above).
    substituteInPlace playwright/_impl/_driver.py \
      --replace "@driver@" "${driver}/bin/playwright"
  '';

  preInstall = ''
    # pip names the wheel "dist", but when installing it will expect a properly formatted filename
    # in dist.
    mv dist dist.orig
    mkdir -p dist
    mv dist.orig dist/playwright-${version}-py3-none-any.whl
  '';

  postInstall = ''
    pushd $out/${python.sitePackages}/playwright
    ln -s ${driver} driver
    popd
  '';

  # Skip tests because they require network access.
  doCheck = false;

  pythonImportsCheck = [
    "playwright"
  ];

  passthru = {
    inherit driver;
    browsers = {
      x86_64-linux = browsers-linux;
      aarch64-linux = browsers-linux;
      x86_64-darwin = browsers-mac;
      aarch64-darwin = browsers-mac;
    }.${system} or throwSystem;
  };

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick yrd ];
  };
}
