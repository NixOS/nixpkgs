{ stdenv, fetchurl, python, pkgconfig, readline, tdb, talloc, tevent
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42, cmocka
}:

stdenv.mkDerivation rec {
  name = "ldb-1.1.31";

  src = fetchurl {
    url = "mirror://samba/ldb/${name}.tar.gz";
    sha256 = "04d53e2ab5b35688f5ed7a4471f5b273da121016e1af0630b36a36506afaeb46"                                                                                                                                                             ;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python readline tdb talloc tevent popt
    libxslt docbook_xsl docbook_xml_dtd_42
    cmocka
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  stripDebugList = "bin lib modules";

  meta = with stdenv.lib; {
    description = "A LDAP-like embedded database";
    homepage = http://ldb.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
