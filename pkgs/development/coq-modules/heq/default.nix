{lib, fetchzip, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "heq";
  repo = "Heq";
  owner = "gil";
  domain = "mpi-sws.org";
  inherit version fetcher;
  defaultVersion = if versions.isLt "8.8" coq.coq-version then "0.92" else null;
  release."0.92".sha256 = "0cf8y6728n81wwlbpq3vi7l2dbzi7759klypld4gpsjjp1y1fj74";

  mlPlugin = true;
  propagatedBuildInputs = [ coq ];

  extraInstallFlags = [ "COQLIB=$out/lib/coq/${coq.coq-version}" ];
  preBuild = "cd src";

  meta = {
    homepage = "https://www.mpi-sws.org/~gil/Heq/";
    description = "Heq : a Coq library for Heterogeneous Equality";
    maintainers = with maintainers; [ jwiegley ];
  };
}
