{ stdenv, fetchurl, python, pkgconfig, readline, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tevent-0.9.26";

  src = fetchurl {
    url = "mirror://samba/tevent/${name}.tar.gz";
    sha256 = "1gbh6d2m49j1v2hkaiyrh8bj02i5wxd4hqayzk2g44yyivbi8b16";
  };

  buildInputs = [
    python pkgconfig readline talloc libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "An event system based on the talloc memory management library";
    homepage = http://tevent.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
