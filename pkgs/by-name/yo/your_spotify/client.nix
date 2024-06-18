{
  apiEndpoint ? "http://localhost:3000",
  fetchYarnDeps,
  your_spotify,
  mkYarnPackage,
  fixup-yarn-lock,
  src,
  version,
  yarn,
}:
mkYarnPackage rec {
  inherit version src;
  pname = "your_spotify_client";
  name = "your_spotify_client-${version}";
  packageJSON = ./package.json;
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-5SgknaRVzgO2Dzc8MhAaM8UERWMv+PrItzevoWHbWnA=";
  };
  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild
    pushd ./apps/client/
    yarn --offline run build
    export API_ENDPOINT="${apiEndpoint}"
    substituteInPlace scripts/run/variables.sh --replace-quiet '/app/apps/client/' "./"

    chmod +x ./scripts/run/variables.sh
    patchShebangs --build ./scripts/run/variables.sh

    ./scripts/run/variables.sh

    popd
    runHook postBuild
  '';
  nativeBuildInputs = [yarn fixup-yarn-lock];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./apps/client/build/* $out
    runHook postInstall
  '';
  doDist = false;
  meta = {
    inherit (your_spotify.meta) homepage changelog description license maintainers;
  };
}
