{
  lib,
  stdenvNoCC,
  fetchFromTangled,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  pnpm = pnpm_11;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tranquil-frontend";
  version = "0.7.0";

  src = fetchFromTangled {
    did = "did:plc:jj6ajj6duxnlthwtnob4qyuv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QbncR2z9GhxKKbbCf6a5Ph4lLi4OYWjRN49s7+5q7Uc=";
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
