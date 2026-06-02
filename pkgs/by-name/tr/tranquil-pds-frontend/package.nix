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
  version = "0.6.4";

  src = fetchgit {
    url = "https://tangled.org/tranquil.farm/tranquil-pds";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kGB5jFwghMsjlAoS4mj94s9peo7PL54UKTH/3TS567w=";
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
    hash = "sha256-9G74AVRXPgR+aj00ksCc1+dDqgE2GQR4cpjJsY6yjro=";
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
