{ lib
, fetchurl
, buildDunePackage
, camlp-streams
, cstruct
, decompress
}:

buildDunePackage rec {
  pname = "tar";
  version = "3.1.2";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${version}/tar-${version}.tbz";
    hash = "sha256-hceTCKQdPVlLmM/kLq7ka4dYVXSOsPDkipeFBCvtFqM=";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    camlp-streams
    cstruct
    decompress
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files in pure OCaml";
    homepage = "https://github.com/mirage/ocaml-tar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
