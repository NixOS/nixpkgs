{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "librsync-0.9.7";

  src = fetchurl {
    url = mirror://sourceforge/librsync/librsync-0.9.7.tar.gz;
    sha256 = "1mj1pj99mgf1a59q9f2mxjli2fzxpnf55233pc1klxk2arhf8cv6";
  };

  hardeningDisable = [ "format" ];

  configureFlags = [
    (stdenv.lib.enableFeature stdenv.isCygwin    "static")
    (stdenv.lib.enableFeature (!stdenv.isCygwin) "shared")
  ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = {
    homepage = http://librsync.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = stdenv.lib.platforms.unix;
  };
}
