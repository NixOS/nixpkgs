{ stdenv, fetchurl, python, pkgconfig, which, readline, tdb, talloc, tevent, lmdb
, popt, libxslt, docbook_xsl, docbook_xml_dtd_42, cmocka
}:

stdenv.mkDerivation rec {
  pname = "ldb";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "01livdy3g073bm6xnc8zqnqrxg53sw8q66d1903z62hd6g87whsa"                                                                                                                                                             ;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig which python docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [
    readline tdb talloc tevent popt lmdb
    libxslt python
    cmocka
  ];

  preConfigure = ''
    patchShebangs buildtools/bin/waf
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
