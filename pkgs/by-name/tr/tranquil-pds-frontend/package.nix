{
  lib,
  stdenvNoCC,
  fetchgit,
  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tranquil-frontend";
  version = "0.6.5";

  src = fetchgit {
    url = "https://tangled.org/tranquil.farm/tranquil-pds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBy982B9ZY5W02hmdKqlR86ynJAUD98b4UgaYIPaFzM=";
  };
  sourceRoot = "${finalAttrs.src.name}/frontend";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-+P4UUkZKQJVfGbDFKR0gRMU+wYK9K7NBYo1s/ebRK9I=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pnpm
    nodejs
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r ./dist $out
    runHook postInstall
  '';

  meta = {
    description = "First party frontend for the Tranquil PDS implementation";
    homepage = "https://tangled.org/tranquil.farm/tranquil-pds";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ nelind ];
  };
})
