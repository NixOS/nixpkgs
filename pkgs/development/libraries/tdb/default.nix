{ stdenv, fetchurl, python, pkgconfig, which, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "tdb";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0d9d2f1c83gmmq30bkfs50yb8399mr9xjjzscma4kyq0ajf75861";
  };

  nativeBuildInputs = [ pkgconfig python which docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [ readline libxslt python ];

  preConfigure = ''
    patchShebangs buildtools/bin/waf
  '';

  configureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-compile"
    "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
  ];
  configurePlatforms = [ ];

  meta = with stdenv.lib; {
    description = "The trivial database";
    longDescription = ''
      TDB is a Trivial Database. In concept, it is very much like GDBM,
      and BSD's DB except that it allows multiple simultaneous writers
      and uses locking internally to keep writers from trampling on each
      other. TDB is also extremely small.
    '';
    homepage = https://tdb.samba.org/;
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}
