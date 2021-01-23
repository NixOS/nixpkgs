{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation rec {
  pname = "stdpp";
  inherit version;
  domain = "gitlab.mpi-sws.org";
  owner = "iris";
  defaultVersion = if versions.range "8.8" "8.12" coq.coq-version then "1.4.0" else null;
  release."1.4.0".sha256 = "1m6c7ibwc99jd4cv14v3r327spnfvdf3x2mnq51f9rz99rffk68r";
  releaseRev = v: "coq-stdpp-${v}";

  meta = {
    description = "An extended “Standard Library” for Coq";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
