{ stdenv, fetchurl, python, pkgconfig, readline, tdb, talloc, tevent
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42, cmocka
}:

stdenv.mkDerivation rec {
  name = "ldb-1.3.3";

  src = fetchurl {
    url = "mirror://samba/ldb/${name}.tar.gz";
    sha256 = "14gsrm7dvyjpbpnc60z75j6fz2p187abm2h353lq95kx2bv70c1b"                                                                                                                                                             ;
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
    homepage = https://ldb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
