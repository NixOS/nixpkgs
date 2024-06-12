{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, fixup-yarn-lock
, yarn
}:

stdenv.mkDerivation rec {
  pname = "pkg";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "pkg";
    rev = version;
    hash = "sha256-h3rHR3JE9hVcd3oiE7VL2daYXGTQo7NcOHGC6pmE/xs=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-KesP3X7LwZ7KSIxcCPXdn/sWcX9TJlwT9z/SdotS2ZQ=";
  };

  nativeBuildInputs  = [
    makeWrapper
    nodejs
    fixup-yarn-lock
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline prepare

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/pkg"
    cp -r . "$out/lib/node_modules/pkg"

    makeWrapper "${nodejs}/bin/node" "$out/bin/pkg" \
      --add-flags "$out/lib/node_modules/pkg/lib-es5/bin.js"

    runHook postInstall
  '';

  meta = {
    description = "Package your Node.js project into an executable";
    homepage = "https://github.com/vercel/pkg";
    license = lib.licenses.mit;
    mainProgram = "pkg";
    maintainers = with lib.maintainers; [ cmcdragonkai ];
    platforms = lib.platforms.all;
  };
}
