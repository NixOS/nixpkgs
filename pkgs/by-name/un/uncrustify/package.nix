{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uncrustify";
  version = "0.82.0";

  src = fetchFromGitHub {
    owner = "uncrustify";
    repo = "uncrustify";
    rev = "uncrustify-${finalAttrs.version}";
    sha256 = "sha256-sBIjBN3tP/gwTWHDLwonEIfk3OduqQtixn4sn28V7pI=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  meta = {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    mainProgram = "uncrustify";
    homepage = "https://uncrustify.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
