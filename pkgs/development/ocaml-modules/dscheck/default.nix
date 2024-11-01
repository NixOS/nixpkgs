{ lib, fetchurl, buildDunePackage
, containers
, oseq
, alcotest
}:

buildDunePackage rec {
  pname = "dscheck";
  version = "0.5.0";

  minimalOCamlVersion = "5.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/dscheck/releases/download/${version}/dscheck-${version}.tbz";
    hash = "sha256-9Rm2DmdvVeCkgAWCvkYdQTj94wmU7JkY8UI3fReIaG0=";
  };

  propagatedBuildInputs = [ containers oseq ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Traced atomics";
    homepage = "https://github.com/ocaml-multicore/dscheck";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
