{stdenv, fetchurl, lib, cmake, qt4, perl, gmp, taglib, boost, gettext,
 kdelibs, kdepimlibs, kdebase_workspace, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "ktorrent-3.3.2";
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.3.2/ktorrent-3.3.2.tar.bz2;
    sha256 = "08s67nz6wml5bx595czw2gcvrfb09hw1n1rzbj1n8iprr1abcpz1";
  };
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  cmakeFlags = "-DTASKMANAGER_INCLUDE_DIR=${kdebase_workspace}/include";
  buildInputs = [ cmake qt4 perl gmp taglib boost gettext stdenv.gcc.libc
                  kdelibs kdepimlibs kdebase_workspace automoc4 phonon qca2 ];
  meta = {
    description = "KDE integrated BitTorrent client";
    license = "GPL";
    homepage = http://ktorrent.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
