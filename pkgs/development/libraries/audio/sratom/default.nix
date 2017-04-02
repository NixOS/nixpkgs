{ stdenv, fetchurl, lv2, pkgconfig, python, serd, sord }:

stdenv.mkDerivation rec {
  name = "sratom-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "0hrxd9i66s06bpn6i3s9ka95134g3sm8yscmif7qgdzhyjqw42j4";
  };

  buildInputs = [ lv2 pkgconfig python serd sord ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sratom;
    description = "A library for serialising LV2 atoms to/from RDF";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
