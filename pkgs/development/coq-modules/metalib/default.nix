{ lib, mkCoqDerivation, coq, version ? null }:

with lib; mkCoqDerivation {
  pname = "metalib";
  owner = "plclub";
  inherit version;
  defaultVersion = if versions.range "8.10" "8.13" coq.coq-version then "20200527" else null;
  release."20200527".rev    = "597fd7d0c93eb159274e84a39d554f10f1efccf8";
  release."20200527".sha256 = "0wbypc05d2lqfm9qaw98ynr5yc1p0ipsvyc3bh1rk9nz7zwirmjs";

  sourceRoot = "source/Metalib";
  installFlags = "COQMF_COQLIB=$(out)/lib/coq/${coq.coq-version}";

  meta = {
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
  };
}
