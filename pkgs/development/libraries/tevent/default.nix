{ stdenv, fetchurl, python, pkgconfig, which, readline, talloc
, libxslt, docbook_xsl, docbook_xml_dtd_42
}:

stdenv.mkDerivation rec {
  pname = "tevent";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1rm4d9245ya15wyrh9vqn1dnz14l2ic88mr46ykyc6kdrl99dwrk";
  };

  nativeBuildInputs = [ pkgconfig python docbook_xsl docbook_xml_dtd_42 which ];
  buildInputs = [
    python readline talloc libxslt
  ];

  preConfigure = ''
    patchShebangs buildtools/bin/waf
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
