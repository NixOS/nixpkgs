{ lib
, fetchurl
, buildDunePackage
, camlp-streams
, ppx_cstruct
, cstruct
, decompress
}:

buildDunePackage rec {
  pname = "tar";
  version = "2.2.2";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${version}/tar-${version}.tbz";
    hash = "sha256-Q+41LPFZFHi9sXKFV3F13FZZNO3KXRSElEmr+nH58Uw=";
  };

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    camlp-streams
    cstruct
    decompress
  ];

  buildInputs = [
    ppx_cstruct
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files in pure OCaml";
    homepage = "https://github.com/mirage/ocaml-tar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
