{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
  flex,
  bison,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "tikzit";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "tikzit";
    repo = "tikzit";
    rev = "v2.1.6";
    sha256 = "0ba99pgv54pj1xvhrwn9db2w0v4h07vsjajcnhpa2smy88ypg32h";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.qttools
    flex
    bison
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
    libsForQt5.poppler
  ];

  # src/data/tikzlexer.l:29:10: fatal error: tikzparser.parser.hpp: No such file or directory
  enableParallelBuilding = false;

  meta = {
    description = "Graphical tool for rapidly creating graphs and diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a simple GUI editor for graphs and string diagrams.
      Its native file format is a subset of PGF/TikZ, which means TikZiT files
      can be included directly in papers typeset using LaTeX.
      For preview support the texlive package 'preview' has to be installed.
    '';
    homepage = "https://tikzit.github.io/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.iblech
      lib.maintainers.mgttlinger
    ];
    mainProgram = "tikzit";
  };
}
