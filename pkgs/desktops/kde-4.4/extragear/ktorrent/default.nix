{stdenv, fetchurl, lib, cmake, qt4, perl, gmp, taglib, boost, gettext,
 kdelibs, kdepimlibs, kdebase_workspace, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "ktorrent-3.3.4";
  src = fetchurl {
    url = http://ktorrent.org/downloads/3.3.4/ktorrent-3.3.4.tar.bz2;
    sha256 = "09lq5140135v9919k4wfmqww5jm17yvyqny8hlk10zyzd42vh7zk";
  };
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
