{
  lib,
  stdenvNoCC,
  nodejs,
  yarn-berry,
  cacert,
  version,
  src,
}:

let
  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/tilt-dev/tilt/blob/master/web/package.json#L94
    ./yarn-4.14-support.patch
  ];
in
stdenvNoCC.mkDerivation {
  pname = "tilt-assets";
  src = "${src}/web";
  inherit version patches;

  nativeBuildInputs = [
    nodejs
    yarn-berry
  ];

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "tilt-assets-deps";
    src = "${src}/web";

    inherit patches;

    nativeBuildInputs = [ yarn-berry ];

    supportedArchitectures = builtins.toJSON {
      os = [
        "darwin"
        "linux"
      ];
      cpu = [
        "arm"
        "arm64"
        "ia32"
        "x64"
      ];
      libc = [
        "glibc"
        "musl"
      ];
    };

    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    configurePhase = ''
      runHook preConfigure

      export HOME="$NIX_BUILD_TOP"
      export YARN_ENABLE_TELEMETRY=0

      yarn config set enableGlobalCache false
      yarn config set cacheFolder $out
      yarn config set supportedArchitectures --json "$supportedArchitectures"

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      yarn install --immutable --mode skip-build

      runHook postBuild
    '';

    dontInstall = true;

    outputHashAlgo = "sha256";
    outputHash = "sha256-3P42xJ1tBVRpe1hNDy4ax9bUmiaPnSZolTGmsKpzYUA=";
    outputHashMode = "recursive";
  };

  configurePhase = ''
    runHook preConfigure

    export HOME="$NIX_BUILD_TOP"
    export YARN_ENABLE_TELEMETRY=0

    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --immutable --immutable-cache
    yarn build

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/. $out/
  '';

  meta = {
    description = "Assets needed for Tilt";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anton-dessiatov ];
    platforms = lib.platforms.all;
  };
}
