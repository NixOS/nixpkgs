{ lib
, fetchFromGitLab
, buildDunePackage
, bls12-381
}:

buildDunePackage rec {
  pname = "bls12-381-hash";
  version = "1.0.0";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "cryptography/ocaml-bls12-381-hash";
    rev = "${version}";
    sha256 = "sha256-cfsSVmN4rbKcLcPcy6NduZktJhPXiVdK75LypmaSe9I=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [ bls12-381 ];

  meta = {
    description = "Implementation of some cryptographic hash primitives using the scalar field of BLS12-381";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/nomadic-labs/privacy-team";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
