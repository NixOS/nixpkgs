{stdenv, fetchurl, lib, cmake, qt4, perl, gmp, taglib, boost, gettext,
 kdelibs, kdepimlibs, kdebase_workspace, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "ktorrent-3.2.3";
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.2.3/ktorrent-3.2.3.tar.bz2;
    sha256 = "1fvxf4wq7w9wl58ms9jnx321b224wzcz685r8dnqw27cy15vxsqd";
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
