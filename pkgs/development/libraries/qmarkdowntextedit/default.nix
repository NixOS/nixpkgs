{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
}:

stdenv.mkDerivation rec {
  pname = "qmarkdowntextedit";
  version = "unstable-2023-04-02";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = pname;
    rev = "a23cc53e7e40e9dcfd0f815b2b3b6a5dc7304405";
    hash = "sha256-EYBX2SJa8o4R/zEjSFbmFxhLI726WY21XmCkWIqPeFc=";
  };

  nativeBuildInputs = [ qmake ];

  dontWrapQtApps = true;

  qmakeFlags = [
    "qmarkdowntextedit-lib.pro"
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  meta = with lib; {
    description = "C++ Qt QPlainTextEdit widget with markdown highlighting and some other goodies";
    homepage = "https://github.com/pbek/qmarkdowntextedit";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wineee ];
  };
}
