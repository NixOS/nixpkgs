{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrectsel";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ropery";
    repo = "xrectsel";
    rev = finalAttrs.version;
    hash = "sha256-9FiThaZhkTMKw63U+CwgDaU0e2R1HLNYN5D9PvwkNF8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libx11 ];

  meta = {
    description = "Print the geometry of a rectangular screen region";
    homepage = "https://github.com/ropery/xrectsel";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "xrectsel";
  };
})
