{ stdenv, fetchurl, python27, pkgconfig, readline, gettext, tdb, talloc, tevent
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42
, acl ? null, heimdal ? null, libaio ? null, libcap ? null, libgcrypt ? null
, sasl ? null, pam ? null, zlib ? null, openldap ? null
}:

stdenv.mkDerivation rec {
  name = "ldb-1.1.18";

  src = fetchurl {
    url = "http://samba.org/ftp/ldb/${name}.tar.gz";
    sha256 = "1j69sla6shzcm5lmsb79c4igsjnx2ggygqmf9yyim9mkl8z9ksig";
  };

  buildInputs = [
    python27 pkgconfig readline gettext tdb talloc tevent popt
    libxslt docbook_xsl docbook_xml_dtd_42
    acl heimdal libaio libcap libgcrypt sasl pam zlib openldap
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python27}/bin/python,g' buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  meta = with stdenv.lib; {
    description = "a LDAP-like embedded database";
    homepage = http://ldb.samba.org/;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
