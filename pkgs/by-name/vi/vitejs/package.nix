{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_12,
  nodejs_24,
  makeWrapper,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vitejs";
  version = "8.3.7";

  src = fetchFromGitHub {
    owner = "vitejs";
    repo = "vite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B0vH2vzeWdeDD8KW3yfh7iAudw5zhIa0GpSnVUhYfPI=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_24
    pnpmConfigHook
    pnpm_12
  ];

  pnpmWorkspaces = [ "vite" ];
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 5;
    hash = "sha256-87uHGALbfIg4nyk6ZcnFzuDrnHqjGIoDOdJkVyI6LW4=";
  };

  buildPhase = ''
    runHook preBuild

    rm -rf packages/vite/dist
    pnpm --filter=vite build-bundle
    pnpm --filter=vite build-types

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
