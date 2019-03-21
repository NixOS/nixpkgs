{ stdenv, fetchurl, python2, pkgconfig, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42, buildPackages
}:

stdenv.mkDerivation rec {
  name = "tdb-1.3.16";

  src = fetchurl {
    url = "mirror://samba/tdb/${name}.tar.gz";
    sha256 = "1ibcz466xwk1x6xvzlgzd5va4lyrjzm3rnjak29kkwk7cmhw4gva";
  };

  nativeBuildInputs = [ pkgconfig python2 ];
  buildInputs = [
    readline libxslt docbook_xsl docbook_xml_dtd_42
  ];

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
