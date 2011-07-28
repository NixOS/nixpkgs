{ stdenv, fetchurl, cmake, automoc4, qt4 }:

stdenv.mkDerivation rec {
  name = "phonon-4.5.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/4.5.0/src/${name}.tar.bz2";
    sha256 = "1p2jhxx3ij9xqxvzdz6fm14b83iag9sk940clgj5jnnw00x93s36";
  };

  buildInputs = [ cmake automoc4 qt4 ];

  preConfigure =
    ''
      substituteInPlace CMakeLists.txt \
        --replace 'PHONON_MKSPECS_DIR}' 'CMAKE_INSTALL_PREFIX}/mkspecs'
      substituteInPlace designer/CMakeLists.txt \
        --replace 'QT_PLUGINS_DIR}' 'CMAKE_INSTALL_PREFIX}/lib/qt4/plugins'
    '';

  meta = {
    homepage = http://phonon.kde.org/;
    description = "Multimedia API for Qt";
    license = "LGPLv2";
  };  
}
