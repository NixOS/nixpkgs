{ stdenv, fetchurl, pkgconfig, autoreconfHook
, librdf_raptor2, ladspaH, openssl, zlib
}:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "liblrdf-${version}";

  src = fetchurl {
    url = "http://github.com/swh/LRDF/archive/${version}.tar.gz";
    sha256 = "18p2flb2sv2hq6w2qkd29z9c7knnwqr3f12i2srshlzx6vwkm05s";
  };

  preAutoreconf = "rm m4/*";
  postPatch = "sed -i -e 's:usr/local:usr:' examples/{instances,remove}_test.c";

  buildInputs = [ pkgconfig autoreconfHook ladspaH openssl zlib ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  meta = {
    description = "Lightweight RDF library with special support for LADSPA plugins";
    homepage = http://sourceforge.net/projects/lrdf/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
