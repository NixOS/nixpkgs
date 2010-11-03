{stdenv, fetchurl, pkgconfig, icu, cluceneCore, curl}:

stdenv.mkDerivation rec {

  version = "1.6.2";

  name = "sword-${version}";

  src = fetchurl {
    url = "http://www.crosswire.org/ftpmirror/pub/sword/source/v1.6/${name}.tar.gz";
    sha256 = "1fc71avaxkhx6kckjiflw6j02lpg569b9bzaksq49i1m87awfxmg";
  };

  buildInputs = [ pkgconfig icu cluceneCore curl ];

  prePatch = ''
    patchShebangs .;
  '';

  configureFlags = "--without-conf --enable-debug";

  meta = {
    description = "A software framework that allows research manipulation of Biblical texts";
    homepage = http://www.crosswire.org/sword/;
    platforms = stdenv.lib.platforms.linux;
    license = "GPLv2";
  };

}

