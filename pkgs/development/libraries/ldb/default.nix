{ stdenv, fetchurl, python, pkgconfig, readline, tdb, talloc, tevent
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "ldb-1.1.27";

  src = fetchurl {
    url = "mirror://samba/ldb/${name}.tar.gz";
    sha256 = "1b1mkl5p8swb67s9aswavhzswlib34hpgsv66zgns009paf2df6d";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python readline tdb talloc tevent popt
    libxslt docbook_xsl docbook_xml_dtd_42
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
