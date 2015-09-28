{ stdenv, fetchFromGitHub, pkgconfig, qt5, libarchive, xorg }:

stdenv.mkDerivation rec {
  version = "0.1.1";
  name = "zeal-${version}";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "v${version}";
    sha256 = "172wf50fq1l5p8hq1irvpwr7ljxkjaby71afrm82jz3ixl6dg2ii";
  };

  buildInputs = [
    xorg.xcbutilkeysyms pkgconfig qt5.base qt5.webkit qt5.imageformats libarchive
  ];

  configurePhase = ''
    qmake PREFIX=/
  '';

  installPhase = ''
    make INSTALL_ROOT=$out install
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (OS X
      app), available for Linux and Windows.
    '';
    homepage = "http://zealdocs.org/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}

