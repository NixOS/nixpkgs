{ config, stdenv, fetchurl, pkgconfig, autoreconfHook
, librdf_raptor2, ladspaH, openssl, zlib
, doCheck ? config.doCheckByDefault or false, ladspaPlugins
}:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "liblrdf-${version}";

  src = fetchurl {
    url = "https://github.com/swh/LRDF/archive/${version}.tar.gz";
    sha256 = "18p2flb2sv2hq6w2qkd29z9c7knnwqr3f12i2srshlzx6vwkm05s";
  };

  postPatch = stdenv.lib.optionalString doCheck ''
    sed -i -e 's:usr/local:${ladspaPlugins}:' examples/{instances,remove}_test.c
  '';

  preAutoreconf = "rm m4/*";
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ladspaH openssl zlib ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  inherit doCheck;

  meta = {
    description = "Lightweight RDF library with special support for LADSPA plugins";
    homepage = https://sourceforge.net/projects/lrdf/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
