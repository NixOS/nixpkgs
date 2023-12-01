{ lib, mkCoqDerivation, coq, Cheerios, InfSeqExt, ssreflect, version ? null }:


mkCoqDerivation {
  pname = "verdi";
  owner = "uwplse";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.9" "8.18"; out = "20230503"; }
    { case = range "8.7" "8.16"; out = "20211026"; }
    { case = range "8.7" "8.14"; out = "20210524"; }
    { case = range "8.7" "8.13"; out = "20200131"; }
    { case = "8.6"; out = "20181102"; }
  ] null;
  release."20230503".rev    = "76833a7b2188e99e358b8439ea6b4f38401c962a";
  release."20230503".sha256 = "sha256-g59adl/FLMlk9vZciz2I1ZX4PDCElNOgVPCwML8E4DU=";
  release."20211026".rev    = "064cc4fb2347453bf695776ed820ffb5fbc1d804";
  release."20211026".sha256 = "sha256:13xrcyzay5sjszf5lg4s44wl9nrcz22n6gi4h95pkpj0ni5clinx";
  release."20210524".rev    = "54597d8ac7ab7dd4dae683f651237644bf77701e";
  release."20210524".sha256 = "sha256:05wb0km2jkhvi8807glxk9fi1kll4lwisiyzkxhqvymz4x6v8xqv";
  release."20200131".rev    = "fdb4ede19d2150c254f0ebcfbed4fb9547a734b0";
  release."20200131".sha256 = "1a2k19f9q5k5djbxplqmmpwck49kw3lrm3aax920h4yb40czkd8m";
  release."20181102".rev    = "25b79cf1be5527ab8dc1b8314fcee93e76a2e564";
  release."20181102".sha256 = "1vw47c37k5vaa8vbr6ryqy8riagngwcrfmb3rai37yi9xhdqg55z";

  propagatedBuildInputs = [ Cheerios InfSeqExt ssreflect ];
}
