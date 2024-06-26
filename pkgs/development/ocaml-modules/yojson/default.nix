{ lib, fetchurl, buildDunePackage, seq }:

buildDunePackage rec {
  pname = "yojson";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    hash = "sha256-zTwdlPaViZoCbf9yaWmJvbENwWMpNLucvm9FmNSvptQ=";
  };

  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "Optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
