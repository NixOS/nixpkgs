{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs_24,
  makeWrapper,
  pnpmConfigHook,
  fetchPnpmDeps,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vitejs";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "vitejs";
    repo = "vite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jcDrGPxTTIQ1mv1wZj5fAqZcfzcXUPoNjeOGg3LHrM8=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpmConfigHook
    pnpm_10
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  pnpmWorkspaces = [ "vite" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 3;
    hash = "sha256-b1JixDkowPI2cl1NSUD+rSyGH5oA7kU07Of1Yi/qPbM=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter=vite build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/vite}
    cp -r {packages,node_modules} $out/lib/vite

    makeWrapper ${lib.getExe nodejs_24} $out/bin/vite \
      --inherit-argv0 \
      --add-flags $out/lib/vite/packages/vite/bin/vite.js

    runHook postInstall
  '';

  meta = {
    description = "Frontend tooling for NodeJS";
    homepage = "https://github.com/vitejs/vite";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "vite";
  };
})
