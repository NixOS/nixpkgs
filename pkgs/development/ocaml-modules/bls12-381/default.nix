<<<<<<< HEAD
{ lib
, buildDunePackage
, fetchFromGitLab
, zarith
, zarith_stubs_js ? null
, integers_stubs_js
, integers
, hex
, alcotest
=======
{ lib, buildDunePackage, fetchFromGitLab
, ff-sig, zarith
, zarith_stubs_js ? null
, integers_stubs_js
, integers, hex
, alcotest, ff-pbt
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDunePackage rec {
  pname = "bls12-381";
<<<<<<< HEAD
  version = "6.1.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "cryptography/ocaml-bls12-381";
    rev = version;
    sha256 = "sha256-z2ZSOrXgm+XjdrY91vqxXSKhA0DyJz6JkkNljDZznX8=";
  };

  minimalOCamlVersion = "4.08";

  postPatch = ''
    patchShebangs ./src/*.sh
  '';

  propagatedBuildInputs = [
    zarith
    zarith_stubs_js
    integers_stubs_js
    hex
    integers
  ];

  checkInputs = [
    alcotest
  ];
=======
  version = "5.0.0";
  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = version;
    sha256 = "sha256-Hy/I+743HSToZgGPFFiAbx7nrybHsE2PwycDsu3DuHM=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    ff-sig
    zarith
    zarith_stubs_js
    integers_stubs_js
    integers
    hex
  ];

  checkInputs = [ alcotest ff-pbt ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = true;

  meta = {
<<<<<<< HEAD
    homepage = "	https://nomadic-labs.gitlab.io/cryptography/ocaml-bls12-381/bls12-381/";
    description = "Implementation of BLS12-381 and some cryptographic primitives built on top of it";
=======
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
