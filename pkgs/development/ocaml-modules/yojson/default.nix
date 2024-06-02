{ lib, fetchurl, buildDunePackage, seq }:

buildDunePackage rec {
  pname = "yojson";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    hash = "sha256-v9wzvvMUG7qaj6ZqiFtUsp9r+rRQBAiE3Yz3zex4RRk=";
  };

  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
