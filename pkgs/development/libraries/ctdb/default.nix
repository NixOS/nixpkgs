{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ctdb-2.5.4";

  src = fetchurl {
    url = "http://samba.org/ftp/ctdb/${name}.tar.gz";
    sha256 = "09fb29ngxnh1crsqchykg23bl6s4fifvxwq4gwg1y742mmnjp9fy";
  };

  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "The trivial database";
    longDescription =
      '' TDB is a Trivial Database. In concept, it is very much like GDBM,
         and BSD's DB except that it allows multiple simultaneous writers and
         uses locking internally to keep writers from trampling on each
         other.  TDB is also extremely small.
      '';
    homepage = http://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
