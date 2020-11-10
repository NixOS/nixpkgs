{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, gtk2 }:

mkDerivation {
  name = "qtstyleplugins-2017-03-11";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtstyleplugins";
    rev = "335dbece103e2cbf6c7cf819ab6672c2956b17b3";
    sha256 = "085wyn85nrmzr8nv5zv7fi2kqf8rp1gnd30h72s30j55xvhmxvmy";
  };

  patches = [ ./fix-build-against-Qt-5.15.patch ];

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ gtk2 ];

  meta = with stdenv.lib; {
    description = "Additional style plugins for Qt5, including BB10, GTK, Cleanlooks, Motif, Plastique";
    homepage = "http://blog.qt.io/blog/2012/10/30/cleaning-up-styles-in-qt5-and-adding-fusion/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
