{ fetchurl, stdenv, zlib, bzip2, libgcrypt, gdbm, gperf, tdb, gnutls, db4,
  libuuid, lzo, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libchop-0.5";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/libchop/libchop-0.5.tar.gz";
    sha256 = "0i7gl0c99pf6794bbwm3iha6a0bciqq969mgwwv6gm9phiiy5s8b";
  };

  buildInputs = [ zlib libgcrypt gdbm gperf bzip2 db4 tdb gnutls libuuid lzo
    pkgconfig ];

  doCheck = true;

  meta = {
    description = "Set of utilities and library for data backup and distributed storage";

    homepage = http://nongnu.org/libchop/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo
      stdenv.lib.maintainers.viric ];
  };
}
