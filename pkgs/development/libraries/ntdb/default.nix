{ stdenv, fetchurl, python, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "ntdb-1.0";

  src = fetchurl {
    url = "http://samba.org/ftp/tdb/${name}.tar.gz";
    sha256 = "0jdzgrz5sr25k83yrw7wqb3r0yj1v04z4s3lhsmnr5z6n5ifhyl1";
  };

  buildInputs = [
    python pkgconfig readline libxslt docbook_xsl docbook_xml_dtd_42
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace,ccan"
  ];

  meta = with stdenv.lib; {
    description = "The not-so trivial database";
    homepage = http://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
