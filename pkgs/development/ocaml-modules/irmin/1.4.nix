{ lib, fetchurl, buildDunePackage, ocaml
, astring, cstruct, fmt, hex, jsonm, logs, ocaml_lwt, ocamlgraph, uri
}:

buildDunePackage rec {
  pname = "irmin";
  version = "1.4.0";

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "019di4cz0z65knl232rnwj26npnc1mqh8j71xbf0mav6x350g1w5";
  };

  propagatedBuildInputs = [ astring cstruct fmt hex jsonm logs ocaml_lwt ocamlgraph uri ];

  doCheck = true;

  meta = with lib; {
    homepage = https://github.com/mirage/irmin;
    description = "Irmin, a distributed database that follows the same design principles as Git";
    license = licenses.isc;
    maintainers = [ maintainers.alexfmpe ];
  };
}
