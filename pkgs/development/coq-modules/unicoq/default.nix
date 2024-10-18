{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "unicoq";
  owner = "unicoq";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.version [
    { case = range "8.19" "8.19"; out = "1.6-${coq.coq-version}"; }
  ] null;
  release."1.6-8.19".sha256 = "sha256-fDk60B8AzJwiemxHGgWjNu6PTu6NcJoI9uK7Ww2AT14=";
  releaseRev = v: "v${v}";
  mlPlugin = true;
  meta = with lib; {
    description = "An enhanced unification algorithm for Coq";
    license = licenses.mit;
  };
  preBuild = ''
    coq_makefile -f _CoqProject -o Makefile
  '';
}
