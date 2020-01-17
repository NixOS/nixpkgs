{ stdenv, fetchurl, lv2, pkgconfig, python3, serd, sord, wafHook }:

stdenv.mkDerivation rec {
  pname = "sratom";
  version = "0.6.2";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "0lz883ravxjf7r9wwbx2gx9m8vhyiavxrl9jdxfppjxnsralll8a";
  };

  nativeBuildInputs = [ pkgconfig wafHook python3 ];
  buildInputs = [ lv2 serd sord ];

  meta = with stdenv.lib; {
    homepage = http://drobilla.net/software/sratom;
    description = "A library for serialising LV2 atoms to/from RDF";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
