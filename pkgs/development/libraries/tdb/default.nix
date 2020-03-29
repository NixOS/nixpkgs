{ stdenv, fetchurl, pkgconfig
, wafHook, python3, readline
, libxslt, docbook_xsl, docbook_xml_dtd_45
}:

stdenv.mkDerivation rec {
  name = "tdb-1.4.3";

  src = fetchurl {
    url = "mirror://samba/tdb/${name}.tar.gz";
    sha256 = "06waz0k50c7v3chd08mzp2rv7w4k4q9isbxx3vhlfpx1vy9q61f8";
  };

  nativeBuildInputs = [
    pkgconfig wafHook
    libxslt docbook_xsl docbook_xml_dtd_45
  ];

  buildInputs = [
    python3 readline
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "The trivial database";
    longDescription = ''
      TDB is a Trivial Database. In concept, it is very much like GDBM,
      and BSD's DB except that it allows multiple simultaneous writers
      and uses locking internally to keep writers from trampling on each
      other. TDB is also extremely small.
    '';
    homepage = https://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
