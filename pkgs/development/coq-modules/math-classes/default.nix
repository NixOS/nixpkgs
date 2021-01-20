{ lib, mkCoqDerivation, coq, bignums, version ? null }:

with lib; mkCoqDerivation {

  pname = "math-classes";
  inherit version;
  defaultVersion = if versions.range "8.6" "8.11" coq.coq-version then "8.11.0" else null;
  release."8.11.0".sha256 = "1hjgncvm1m46lw6264w4dqsy8dbh74vhmzq52x0fba2yqlvy94sf";

  extraBuildInputs = [ bignums ];

  meta = {
    homepage = "https://math-classes.github.io";
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist jwiegley ];
  };
}
