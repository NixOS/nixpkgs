{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ta-lib";
  version = "0.7.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tme5YuTWdf4lCsWXF97kSeka7Vmqte0vTjwtaUNN+kA=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Add technical analysis to your own financial market trading applications";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org/";
    changelog = "https://github.com/TA-Lib/ta-lib-python/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rafael ];
  };
})
