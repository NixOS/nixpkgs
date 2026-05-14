{
  stdenv,
  src,
  version,
  meta,
  pnpmDeps,
  apiEndpoint ? "http://localhost:3000",
  pnpmConfigHook,
  pnpm_9,
  nodejs,
}:

stdenv.mkDerivation {
  pname = "your_spotify_client";
  inherit version src pnpmDeps;

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
    nodejs
  ];

  API_ENDPOINT = "${apiEndpoint}";

  buildPhase = ''
    runHook preBuild

    pushd ./apps/client/
    pnpm run build

    export NODE_ENV=production
    substituteInPlace scripts/run/variables.sh --replace-quiet '/app/apps/client/' "./"
    chmod +x ./scripts/run/variables.sh
    patchShebangs --build ./scripts/run/variables.sh
    ./scripts/run/variables.sh
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./apps/client/build/* $out
    runHook postInstall
  '';

  inherit meta;
}
