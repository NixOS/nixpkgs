{ lib, stdenv, fetchurl, lv2, pkg-config, python3, serd, sord, wafHook }:

stdenv.mkDerivation rec {
  pname = "sratom";
  version = "0.6.8";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-Ossysa3Forf6za3i4IGLzWxx8j+EoevBeBW7eg0tAt8=";
  };

  nativeBuildInputs = [ pkg-config wafHook python3 ];
  buildInputs = [ lv2 serd sord ];
  dontAddWafCrossFlags = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/sratom";
    description = "A library for serialising LV2 atoms to/from RDF";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
