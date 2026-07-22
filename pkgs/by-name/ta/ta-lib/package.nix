{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ta-lib";
  version = "0.6.4";
  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aTRiScPNWsGDwJvumZXlMilvSDYZVDWgpeZ2F/S5WgQ=";
  };
  nativeBuildInputs = [ autoreconfHook ];
  meta = {
    description = "Add technical analysis to your own financial market trading applications";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rafael ];
  };
})
