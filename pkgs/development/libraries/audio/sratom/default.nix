{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord }:

stdenv.mkDerivation rec {
  name = "sratom-${version}";
  version = "0.2.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "12wi0ycjnn6mlddcp476wzr6k2bb4ig1489gg8h1k7v0w7d6ry1a";
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

  };
}
