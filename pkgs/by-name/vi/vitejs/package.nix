{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  nodejs_24,
  makeWrapper,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vitejs";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "vitejs";
    repo = "vite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ewtFvWeNFb6LowvA83p53+ilsMDugLzXK1I63lhZUAU=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpmConfigHook
    pnpm_10
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
    hash = "sha256-02s37dcEvxFlaGO+RNxTMPuTV0/sx7hiX1Nzc3A/qro=";
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
