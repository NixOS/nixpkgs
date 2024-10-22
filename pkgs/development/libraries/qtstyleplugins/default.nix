{ lib, mkDerivation, fetchFromGitHub, fetchpatch, qmake, pkg-config, gtk2 }:

mkDerivation {
  pname = "qtstyleplugins";
  version = "unstable-2017-03-11";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtstyleplugins";
    rev = "335dbece103e2cbf6c7cf819ab6672c2956b17b3";
    sha256 = "085wyn85nrmzr8nv5zv7fi2kqf8rp1gnd30h72s30j55xvhmxvmy";
  };

  patches = [
    (fetchpatch rec {
      name = "0001-fix-build-against-Qt-5.15.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=qt5-styleplugins";
      sha256 = "j0CgfutqFawy11IqFnlrkfMsMD01NjX/MkfVEVxj1QM=";
    })
    (fetchpatch rec {
      name = "0002-fix-gtk2-background.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=qt5-styleplugins";
      sha256 = "qUOkNckrSUEzXY1PUZKfbiCjhNyB5ZBw2IN/j32GKM4=";
    })
  ];

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ gtk2 ];

  meta = with lib; {
    description = "Additional style plugins for Qt5, including BB10, GTK, Cleanlooks, Motif, Plastique";
    homepage = "http://blog.qt.io/blog/2012/10/30/cleaning-up-styles-in-qt5-and-adding-fusion/";
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
