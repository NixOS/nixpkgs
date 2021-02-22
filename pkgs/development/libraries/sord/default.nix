{ lib, stdenv, fetchFromGitHub, pkg-config, python3, serd, pcre, wafHook }:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "unstable-2021-01-12";

  # Commit picked in mitigation of #109729
  src = fetchFromGitHub {
    owner = "drobilla";
    repo = pname;
    rev = "d2efdb2d026216449599350b55c2c85c0d3efb89";
    sha256 = "hHTwK+K6cj9MGO77a1IXiUZtEbXZ08cLGkYZ5eMOIVA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python3 wafHook ];
  buildInputs = [ pcre ];
  propagatedBuildInputs = [ serd ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "A lightweight C library for storing RDF data in memory";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
