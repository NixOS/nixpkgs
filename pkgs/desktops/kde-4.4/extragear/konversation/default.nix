{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "konversation-1.2.1";
  src = fetchurl {
    url = mirror://kde/stable/konversation/1.2.1/src/konversation-1.2.1.tar.bz2;
    sha256 = "1rx4xgw14cfzkxghgn80np8i2ndq26sbdvv96g46r0s14qkdyq8w";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl gettext stdenv.gcc.libc libXScrnSaver kdelibs kdepimlibs automoc4 phonon qca2 ];
  patchPhase = ''
    echo "include_directories(${qt4}/include/QtGui)" > tmp
    cp src/CMakeLists.txt src/CMakeLists.bak
    cat tmp src/CMakeLists.bak > src/CMakeLists.txt
  '';
  meta = {
    description = "Integrated IRC client for KDE";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
