{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ta-lib";
  version = "0.8.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c8OSwb2H4ior015cXu2+SixSlFzLqeb9K19VNk3XEbc=";
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
