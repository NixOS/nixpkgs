{ buildPythonPackage, fetchFromGitHub, lib }:

buildPythonPackage rec {
  pname = "gast";
  version = "0.2.0";

  src = fetchFromGitHub {
    rev = "1de043272fdcb8e01c20bfc3ec53bc00d2d6fe8e";
    owner = "serge-sans-paille";
    repo = "gast";
    sha256 = "0f0f1q5l0j1cgmrfhgax5wzdjadkympf306y259gf6z1wik3nbbz";
  };

  meta = {
    description = "Python AST that abstracts the underlying Python version";
    homepage = https://github.com/serge-sans-paille/gast;
    license = lib.licenses.bsd3;
    maintainers =  with lib.maintainers; [ mredaelli ];
  };
}
