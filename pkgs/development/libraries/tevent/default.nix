{ stdenv, fetchurl, python27, pkgconfig, readline, gettext, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
, acl ? null, heimdal ? null, libaio ? null, libcap ? null, sasl ? null
, pam ? null, zlib ? null, libgcrypt ? null
}:

stdenv.mkDerivation rec {
  name = "tevent-0.9.22";

  src = fetchurl {
    url = "http://samba.org/ftp/tevent/${name}.tar.gz";
    sha256 = "0myyi3lwsi6f3f0a5qw8rjpm2d5yf18pw4vljdwyi885l411sksl";
  };

  buildInputs = [
    python27 pkgconfig readline gettext talloc libxslt docbook_xsl
    docbook_xml_dtd_42
    acl heimdal libaio libcap sasl pam zlib libgcrypt
  ];

  preConfigure = ''
    sed -i 's,#!/usr/bin/env python,#!${python27}/bin/python,g' buildtools/bin/waf
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
