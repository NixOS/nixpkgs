{ lib, mkCoqDerivation, coq, stdpp, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "iris";
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  inherit version;
  defaultVersion = if versions.range "8.9" "8.12" coq.coq-version then "3.3.0" else null;
  release."3.3.0".sha256 = "0az4gkp5m8sq0p73dlh0r7ckkzhk7zkg5bndw01bdsy5ywj0vilp";
  releaseRev = v: "iris-${v}";

  propagatedBuildInputs = [ stdpp ];

  meta = {
    description = "The Coq development of the Iris Project";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
