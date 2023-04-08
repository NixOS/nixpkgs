{ lib, buildDunePackage, fetchFromGitLab
, ff-sig, zarith
, zarith_stubs_js ? null
, integers_stubs_js
, integers, hex
, alcotest, ff-pbt
}:

buildDunePackage rec {
  pname = "bls12-381";
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

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
