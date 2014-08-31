{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord }:

stdenv.mkDerivation rec {
  name = "sratom-${version}";
  version = "0.4.6";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "080jjiyxjnj7hf25844hd9rb01grvzz1rk8mxcdnakywmspbxfd4";
  };

  buildInputs = [ lv2 pkgconfig python serd sord ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sratom;
    description = "A library for serialising LV2 atoms to/from RDF";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
