{ stdenv, fetchFromGitHub, qmake, qtbase, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "qtstyleplugins-2017-03-11";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtstyleplugins";
    rev = "335dbece103e2cbf6c7cf819ab6672c2956b17b3";
    sha256 = "085wyn85nrmzr8nv5zv7fi2kqf8rp1gnd30h72s30j55xvhmxvmy";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ gtk2 ];

  installPhase = ''
    make INSTALL_ROOT=$NIX_QT5_TMP install
    mv $NIX_QT5_TMP/$NIX_QT5_TMP $out
  '';

  meta = with stdenv.lib; {
    description = "Additional style plugins for Qt5, including BB10, GTK+, Cleanlooks, Motif, Plastique";
    homepage = http://blog.qt.io/blog/2012/10/30/cleaning-up-styles-in-qt5-and-adding-fusion/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
