{ lib, mkCoqDerivation, coq, unicoq, version ? null }:

mkCoqDerivation {
  pname = "Mtac2";
  owner = "Mtac2";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.19" "8.19"; out = "1.4-coq${coq.coq-version}"; }
  ] null;
  release."1.4-coq8.19".sha256 = "sha256-G9eK0eLyECdT20/yf8yyz7M8Xq2WnHHaHpxVGP0yTtU=";
  releaseRev = v: "v${v}";
  mlPlugin = true;
  propagatedBuildInputs = [ unicoq ];
  meta = with lib; {
    description = "Typed tactic language for Coq";
    license = licenses.mit;
  };
  preBuild = ''
    coq_makefile -f _CoqProject -o Makefile
    patchShebangs tests/sf-5/configure.sh
  '';
}
