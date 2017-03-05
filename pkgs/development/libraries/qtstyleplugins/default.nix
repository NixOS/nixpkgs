{ stdenv, fetchFromGitHub, qmakeHook, qtbase, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  name = "qtstyleplugins-2016-12-01";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtstyleplugins";
    rev = "7aa47640c202cc4a9c16aa7df98191236743c8ba";
    sha256 = "0pysgn5yhbh85rv7syvf2w9g1gj1z1nwspjri39dc95vj108lin5";
  };

  buildInputs = [ qmakeHook pkgconfig gtk2 ];

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
    broken = builtins.compareVersion qtbase.version "5.7.0" > 0;
  };
}
