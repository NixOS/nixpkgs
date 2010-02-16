{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "konversation-1.2.3";
  src = fetchurl {
    url = mirror://kde/stable/konversation/1.2.3/src/konversation-1.2.3.tar.bz2;
    sha256 = "06h0j6clgb7b208i7y9n93zfqajgd7y0wf853r535rd1ysi3kjmg";
  };
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
