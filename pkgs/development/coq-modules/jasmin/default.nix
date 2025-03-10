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
        out = "2025.02.0"; }
    ] null;
  releaseRev = v: "v${v}";

  release."2025.02.0".sha256 = "sha256-Jlf0+VPuYWXdWyKHKHSp7h/HuCCp4VkcrgDAmh7pi5s=";

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
