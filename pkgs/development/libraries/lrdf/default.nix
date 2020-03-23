{ config, stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, librdf_raptor2, ladspaH, openssl, zlib
, doCheck ? config.doCheckByDefault or false, ladspaPlugins
}:

stdenv.mkDerivation rec {
  pname = "lrdf";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "swh";
    repo = "LRDF";
    rev = "v${version}";
    sha256 = "00wzkfb8y0aqd519ypz067cq099dpc89w69zw8ln39vl6f9x2pd4";
  };

  postPatch = stdenv.lib.optionalString doCheck ''
    sed -i -e 's:usr/local:${ladspaPlugins}:' examples/{instances,remove}_test.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  inherit doCheck;

  enableParallelBuilding = true;

  meta = {
    description = "Lightweight RDF library with special support for LADSPA plugins";
    homepage = https://sourceforge.net/projects/lrdf/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
