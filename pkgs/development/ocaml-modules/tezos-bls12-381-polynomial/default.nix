{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  bls12-381,
  data-encoding,
  alcotest,
  alcotest-lwt,
  bisect_ppx,
  qcheck-alcotest,
}:

buildDunePackage rec {
  pname = "tezos-bls12-381-polynomial";
  version = "0.1.2";
  duneVersion = "3";
  src = fetchFromGitLab {
    owner = "nomadic-labs/cryptography";
    repo = "privacy-team";
    rev = "v${version}";
    sha256 = "sha256-HVeKZCPBRJWQXkcI2J7Fl4qGviYLD5x+4W4pAY/W4jA=";
  };

  propagatedBuildInputs = [bls12-381 data-encoding];

  checkInputs = [alcotest alcotest-lwt bisect_ppx qcheck-alcotest];

  doCheck = false; # circular dependencies

  meta = {
    description = "Polynomials over BLS12-381 finite field";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/nomadic-labs/privacy-team";
    maintainers = [lib.maintainers.ulrikstrid];
  };
}
