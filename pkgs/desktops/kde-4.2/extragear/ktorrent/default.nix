{stdenv, fetchurl, cmake, qt4, perl, gmp, taglib, boost, gettext,
 kdelibs, kdepimlibs, kdebase_workspace, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "ktorrent-3.2.1";
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.2.1/ktorrent-3.2.1.tar.bz2;
    sha256 = "e37324519fdd04cad2a489fb772cbe628d8ff9f578e2bb913b18a1404dd7c4eb";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  cmakeFlags = "-DTASKMANAGER_INCLUDE_DIR=${kdebase_workspace}/include";
  buildInputs = [ cmake qt4 perl gmp taglib boost gettext stdenv.gcc.libc
                  kdelibs kdepimlibs kdebase_workspace automoc4 phonon qca2 ];
}
