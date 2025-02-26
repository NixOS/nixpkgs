{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp,
  mathcomp-algebra-tactics,
  mathcomp-word,
  version ? null,
}:

mkCoqDerivation {
  pname = "jasmin";
  owner = "jasmin-lang";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch [ coq.version mathcomp.version ] [
      { cases = [ (range "8.18" "8.20") (range "2.2" "2.3") ];
        out = "2024.07.3"; }
    ] null;
  releaseRev = v: "v${v}";

  release."2024.07.3".sha256 = "sha256-n/X8d7ILuZ07l24Ij8TxbQzAG7E8kldWFcUI65W4r+c=";

  propagatedBuildInputs = [
    mathcomp-algebra-tactics
    mathcomp-word
  ];

  makeFlags = [ "-C" "proofs" ];

  meta = with lib; {
    description = "Jasmin language & verified compiler";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = licenses.mit;
    maintainers = with maintainers; [ proux01 vbgl ];
  };
}
