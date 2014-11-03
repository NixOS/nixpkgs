{ stdenv, fetchurl, pkgconfig, libtool, automake, autoconf
, librdf_raptor, librdf_raptor2, ladspaH, openssl, zlib #, swh_lv2
}:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "liblrdf-${version}";

  src = fetchurl {
    url = "http://github.com/swh/LRDF/archive/${version}.tar.gz";
    sha256 = "18p2flb2sv2hq6w2qkd29z9c7knnwqr3f12i2srshlzx6vwkm05s";
  };

  postPatch = "sed -i -e 's:usr/local:usr:' examples/{instances,remove}_test.c";

  preConfigure = "rm m4/* && autoreconf -if";

  buildInputs = [
    pkgconfig libtool automake autoconf ladspaH openssl zlib /*swh_lv2*/
    #librdf_raptor 
  ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  #doCheck = true; # would need swh_lv2 and some path patching

  meta = {
    description = "Lightweight RDF library with special support for LADSPA plugins";
    homepage = http://sourceforge.net/projects/lrdf/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
