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
    description = "The GNU Transport Layer Security Library";

    longDescription = ''
       GnuTLS is a project that aims to develop a library which
       provides a secure layer, over a reliable transport
       layer. Currently the GnuTLS library implements the proposed
       standards by the IETF's TLS working group.

       Quoting from the TLS protocol specification:

       "The TLS protocol provides communications privacy over the
       Internet. The protocol allows client/server applications to
       communicate in a way that is designed to prevent eavesdropping,
       tampering, or message forgery."
    '';

    homepage = http://nongnu.org/libchop/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.viric ];
  };
}
