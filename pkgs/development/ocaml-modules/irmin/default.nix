{ lib, fetchurl, buildDunePackage
, astring, base64, digestif, fmt, jsonm, logs, ocaml_lwt, ocamlgraph, uri
, alcotest, hex
}:

buildDunePackage rec {

  pname = "irmin";
  version = "2.1.0";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "1ji8r7zbdmhbk8r8w2hskd9z7pnvirzbhincfxndxgdaxbfkff5g";
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
