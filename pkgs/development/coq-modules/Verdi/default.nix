{ lib, mkCoqDerivation, coq, Cheerios, InfSeqExt, ssreflect, version ? null }:


with lib; mkCoqDerivation {
  pname = "verdi";
  owner = "uwplse";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.7"; out = "20200131"; }
    { case = isEq "8.6"; out = "20181102"; }
  ] null;
  release."20200131".rev    = "fdb4ede19d2150c254f0ebcfbed4fb9547a734b0";
  release."20200131".sha256 = "1a2k19f9q5k5djbxplqmmpwck49kw3lrm3aax920h4yb40czkd8m";
  release."20181102".rev    = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
  release."20181102".sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";

  propagatedBuildInputs = [ Cheerios InfSeqExt ssreflect ];
  preConfigure = "patchShebangs ./configure";
}
