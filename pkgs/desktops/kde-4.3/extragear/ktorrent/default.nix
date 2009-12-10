{stdenv, fetchurl, lib, cmake, qt4, perl, gmp, taglib, boost, gettext,
 kdelibs, kdepimlibs, kdebase_workspace, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "ktorrent-3.3.1";
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.3.1/ktorrent-3.3.1.tar.bz2;
    sha256 = "15cyq9bixism15qb3g196ga47q6iyw68sizclcn43nw91g0xl9r1";
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
