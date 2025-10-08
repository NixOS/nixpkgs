{
  lib,
  stdenvNoCC,
  nodejs,
  yarn-berry,
  cacert,
  version,
  src,
}:

stdenvNoCC.mkDerivation {
  pname = "tilt-assets";
  src = "${src}/web";
  inherit version;

  nativeBuildInputs = [
    nodejs
    yarn-berry
  ];

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "tilt-assets-deps";
    src = "${src}/web";

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
    outputHash = "sha256-UdNvUSz86E1W1gVPQrxt5g3Z3JIX/tq8rI5E8+h20PI=";
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

  meta = with lib; {
    description = "Assets needed for Tilt";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anton-dessiatov ];
    platforms = platforms.all;
  };
}
