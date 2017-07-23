{ stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, qtx11extras, libX11, libXext, qttools }:

stdenv.mkDerivation rec {
  name = "qtstyleplugin-kvantum-${version}";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "0527bb03f2252269fd382e11181a34ca72c96b4b";
    sha256 = "0ky44s1fgqxraywagx1mv07yz76ppgiz3prq447db78wkwqg2d8p";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras libX11 libXext  ];
=======
  nativeBuildInputs = [ qmake qtbase qtsvg qtx11extras libX11 libXext qttools ];
>>>>>>> 1749de44b63cdf5f015087646b34e8eedf221a24

  postUnpack = "sourceRoot=\${sourceRoot}/Kvantum";

  postInstall= ''
    mkdir -p $out/$qtPluginPrefix/styles
    mv $NIX_QT5_TMP/$qtPluginPrefix/styles/libkvantum.so $out/$qtPluginPrefix/styles/libkvantum.so
  '';

  meta = with stdenv.lib; {
<<<<<<< HEAD
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
=======
    description = "A Linux SVG-based theme engine for Qt4/Qt5 and KDE";
>>>>>>> 1749de44b63cdf5f015087646b34e8eedf221a24
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
