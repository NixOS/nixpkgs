{ stdenv
, fetchurl
, python
, pkg-config
, readline
, talloc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  pname = "tevent";
  version = "0.9.37";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "1q77vbjic2bb79li2a54ffscnrnwwww55fbpry2kgh7acpnlb0qn";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    python
    readline
    talloc
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
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
    homepage = "https://tevent.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
