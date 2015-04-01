{ stdenv, fetchurl, python, pkgconfig, readline, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tevent-0.9.24";

  src = fetchurl {
    url = "mirror://samba/tevent/${name}.tar.gz";
    sha256 = "0l1zjx2z6nhvn6gwbcvzn8w0cca53j717fwi10s7a5v1jb04rfad";
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
