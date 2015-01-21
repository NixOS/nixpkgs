{ stdenv, fetchurl, python, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "talloc-2.1.1";

  src = fetchurl {
    url = "http://samba.org/ftp/talloc/${name}.tar.gz";
    sha256 = "0x31id42b425dbxv5whrqlc6dj14ph7wzs3wsp1ggi537dncwa9y";
  };

  buildInputs = [
    python pkgconfig readline libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = http://tdb.samba.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
