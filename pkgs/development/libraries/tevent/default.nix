{ stdenv, fetchurl, python, pkgconfig, readline, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tevent-0.9.22";

  src = fetchurl {
    url = "http://samba.org/ftp/tevent/${name}.tar.gz";
    sha256 = "0myyi3lwsi6f3f0a5qw8rjpm2d5yf18pw4vljdwyi885l411sksl";
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
    description = "an event system based on the talloc memory management library.";
    homepage = http://tevent.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
