{ lib, mkCoqDerivation, coq, ssreflect, version ? null }:

mkCoqDerivation {

  pname = "coq-haskell";
  owner = "jwiegley";
  inherit version;
  defaultVersion = if lib.versions.range "8.5" "8.8" coq.coq-version then "20171215" else null;
  release."20171215".rev    = "e2cf8b270c2efa3b56fab1ef6acc376c2c3de968";
  release."20171215".sha256 = "09dq1vvshhlhgjccrhqgbhnq2hrys15xryfszqq11rzpgvl2zgdv";

  mlPlugin = true;
  extraInstallFlags = [ "-f Makefile.coq" ];
  propagatedBuildInputs = [ coq ssreflect ];
  enableParallelBuilding = false;

  meta = {
    description = "A library for formalizing Haskell types and functions in Coq";
    maintainers = with lib.maintainers; [ jwiegley ];
  };
}
