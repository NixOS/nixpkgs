{
  lib,
  stdenv,
  wox,
  fetchPnpmDeps,
  nodejs,
  pnpmConfigHook,
  pnpm_9,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wox-plugin-host-nodejs";
  inherit (wox)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/wox.plugin.host.nodejs";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-cbuVQV8ih8rztERFLUHGnK63MBz8+QVmzeegYLDwcj4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/index.js $out/node-host.js

    runHook postInstall
  '';

  meta = {
    inherit (wox.meta)
      description
      homepage
      license
      maintainers
      ;
  };
})
