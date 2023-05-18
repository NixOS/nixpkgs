{ lib
, fetchFromGitLab
, buildDunePackage
, bls12-381
, data-encoding
, bigstringaf
, alcotest
, alcotest-lwt
, bisect_ppx
, qcheck-alcotest
, ppx_repr
}:

buildDunePackage rec {
  pname = "tezos-bls12-381-polynomial";
  version = "1.0.1";
  duneVersion = "3";
  src = fetchFromGitLab {
    owner = "nomadic-labs/cryptography";
    repo = "privacy-team";
    rev = "v${version}";
    sha256 = "sha256-5qDa/fQoTypjaceQ0MBzt0rM+0hSJcpGlXMGAZKRboo=";
  };

  propagatedBuildInputs = [ ppx_repr bls12-381 data-encoding bigstringaf ];

  checkInputs = [ alcotest alcotest-lwt bisect_ppx qcheck-alcotest ];

  doCheck = false; # circular dependencies

  meta = {
    description = "Polynomials over BLS12-381 finite field";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/nomadic-labs/privacy-team";
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
