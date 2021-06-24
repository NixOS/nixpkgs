{ lib, stdenv, fetchurl, pkg-config, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "serd";
  version = "0.30.10";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-r/qA3ux4kh+GM15vw/GLgK7+z0JPaldV6fL6DrBxDt8=";
  };

  nativeBuildInputs = [ pkg-config python3 wafHook ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/serd";
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
