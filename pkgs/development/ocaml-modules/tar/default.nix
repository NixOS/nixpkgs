{ lib
, fetchurl
, buildDunePackage
, camlp-streams
<<<<<<< HEAD
=======
, ppx_cstruct
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cstruct
, decompress
}:

buildDunePackage rec {
  pname = "tar";
<<<<<<< HEAD
  version = "2.5.1";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${version}/tar-${version}.tbz";
    hash = "sha256-00QPSIZnoFvhZEnDcdEDJUqhE0uKLxNMM2pUE8aMPfQ=";
  };

=======
  version = "2.2.2";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${version}/tar-${version}.tbz";
    hash = "sha256-Q+41LPFZFHi9sXKFV3F13FZZNO3KXRSElEmr+nH58Uw=";
  };

  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    camlp-streams
    cstruct
    decompress
  ];

<<<<<<< HEAD
=======
  buildInputs = [
    ppx_cstruct
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  meta = {
    description = "Decode and encode tar format files in pure OCaml";
    homepage = "https://github.com/mirage/ocaml-tar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
