{ stdenv, fetchurl, wafHook, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tdb-1.3.16";

  src = fetchurl {
    url = "mirror://samba/tdb/${name}.tar.gz";
    sha256 = "1ibcz466xwk1x6xvzlgzd5va4lyrjzm3rnjak29kkwk7cmhw4gva";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [
    readline libxslt docbook_xsl docbook_xml_dtd_42
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
