{ lib, mkCoqDerivation, coq, bignums, version ? null }:

with lib; mkCoqDerivation {

  pname = "math-classes";
  inherit version;
  defaultVersion = if versions.range "8.6" "8.12" coq.coq-version then "8.12.0" else null;
  release."8.12.0".sha256 = "14nd6a08zncrl5yg2gzk0xf4iinwq4hxnsgm4fyv07ydbkxfb425";

  extraBuildInputs = [ bignums ];

  meta = {
    homepage = "https://math-classes.github.io";
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist jwiegley ];
  };
}
