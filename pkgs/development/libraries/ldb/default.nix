{ lib, stdenv
, fetchurl
, python3
, pkg-config
, readline
, tdb
, talloc
, tevent
, popt
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, cmocka
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "ldb";
  version = "2.3.0";

  src = fetchurl {
    url = "mirror://samba/ldb/${pname}-${version}.tar.gz";
    sha256 = "0bcjj4gv48ddg44wyxpsvrs26xry6yy9x9k16qgz0bljs2rhilx4";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
  ];

  buildInputs = [
    python3
    readline # required to build python
    tdb
    talloc
    tevent
    popt
    cmocka
  ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
    "--without-ldb-lmdb"
  ];

  stripDebugList = [ "bin" "lib" "modules" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A LDAP-like embedded database";
    homepage = "https://ldb.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
