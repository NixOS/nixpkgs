{ lib, fetchurl, buildDunePackage
, astring, base64, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, alcotest, hex
}:

buildDunePackage rec {

  pname = "irmin";
  version = "2.0.0";

  minimumOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "09qffvgi5yrm3ghiywlbdhjly8xb5x5njnan213q8j033fzmf2dr";
  };

  propagatedBuildInputs = [ astring base64 digestif fmt jsonm logs ocaml_lwt ocamlgraph uri ];

  checkInputs = lib.optionals doCheck [ alcotest hex ];

  doCheck = true;

  meta = {
    homepage = "https://irmin.org/";
    description = "A distributed database built on the same principles as Git";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
