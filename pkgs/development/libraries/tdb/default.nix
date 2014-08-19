{ fetchurl, stdenv, libxslt, libxml2, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "tdb-1.2.1";

  src = fetchurl {
    url = "http://samba.org/ftp/tdb/${name}.tar.gz";
    sha256 = "1yndfc2hn28v78vgvrds7cjggmmhf9q5dcfklgdfvpsx9j9knhpg";
  };

  buildInputs = [ libxslt libxml2 docbook_xsl ];

  meta = {
    description = "TDB, the trivial database";
    longDescription =
      '' TDB is a Trivial Database. In concept, it is very much like GDBM,
         and BSD's DB except that it allows multiple simultaneous writers and
         uses locking internally to keep writers from trampling on each
         other.  TDB is also extremely small.
      '';

    homepage = http://tdb.samba.org/;
    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
