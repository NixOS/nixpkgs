{ stdenv, fetchurl, python, pkgconfig, readline, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  name = "tevent-0.9.37";

  src = fetchurl {
    url = "mirror://samba/tevent/${name}.tar.gz";
    sha256 = "1q77vbjic2bb79li2a54ffscnrnwwww55fbpry2kgh7acpnlb0qn";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python readline talloc libxslt docbook_xsl docbook_xml_dtd_42
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
    homepage = https://tevent.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
