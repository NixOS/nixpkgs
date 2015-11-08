{ stdenv, fetchurl, python, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tdb-1.3.8";

  src = fetchurl {
    url = "mirror://samba/tdb/${name}.tar.gz";
    sha256 = "1cg6gmpgn36dd4bsp3j9k3hyrm87d8hdigqyyqxw5jga4w2aq186";
  };

  buildInputs = [
    python pkgconfig readline libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

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
