{ lib, buildDunePackage, fetchFromGitLab
, sedlex, uunf, uutf
}:

buildDunePackage rec {
  pname = "iri";
<<<<<<< HEAD
  version = "0.7.0";

  minimalOCamlVersion = "4.12";
=======
  version = "0.6.0";
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "ocaml-iri";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Mkg7kIIVpKbeWUras1RqtJsRx2Q3dBnm4QqSMJFweF8=";
=======
    sha256 = "sha256:0zk8nnwcyljkc1a556byncv6cn1vqhk4267z1lm15flh1k7chyax";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ sedlex uunf uutf ];

  meta = {
    description = "IRI (RFC3987) native OCaml implementation";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
