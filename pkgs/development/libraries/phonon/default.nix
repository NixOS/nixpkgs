{ stdenv, fetchurl, cmake, automoc4, qt4, xz }:

let
  v = "4.5.1";
in

stdenv.mkDerivation rec {
  name = "phonon-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${v}/src/${name}.tar.xz";
    sha256 = "1j7lw8w7h2z415vhbp2jlgv3mqwvrspf8xnzb8l0gsfanqfg1001";
  };

  buildInputs = [ qt4 ];

  buildNativeInputs = [ cmake automoc4 xz ];

  cmakeFlags = "-DPHONON_MKSPECS_DIR=mkspecs";
  preConfigure =
    ''
      substituteInPlace designer/CMakeLists.txt \
        --replace '{QT_PLUGINS_DIR}' '{CMAKE_INSTALL_PREFIX}/lib/qt4/plugins'
    '';

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = "LGPLv2";
    platforms = stdenv.lib.platforms.linux;
  };  
}
