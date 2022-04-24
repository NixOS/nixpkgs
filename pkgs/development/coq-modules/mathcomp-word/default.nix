{ coq, mkCoqDerivation, mathcomp, lib, version ? null }:

with lib;
mkCoqDerivation {
  namePrefix = [ "coq" "mathcomp" ];
  pname = "word";
  owner = "jasmin-lang";
  repo = "coqword";
  useDune2 = true;

  releaseRev = v: "v${v}";

  release."1.0".sha256 = "sha256:0703m97rnivcbc7vvbd9rl2dxs6l8n52cbykynw61c6w9rhxspcg";

  inherit version;
  defaultVersion = with versions; switch [ coq.version mathcomp.version ] [
    { cases = [ (range "8.12" "8.14") (isGe "1.12") ]; out = "1.0"; }
  ] null;

  propagatedBuildInputs = [ mathcomp.algebra mathcomp.ssreflect mathcomp.fingroup ];

  meta = {
    description = "Yet Another Coq Library on Machine Words";
    maintainers = [ maintainers.vbgl ];
    license = licenses.mit;
  };
}
