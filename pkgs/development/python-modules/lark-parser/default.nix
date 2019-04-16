{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1zynj09w361yvbxr4hir681dfnlq1hzniws9dzgmlkvd6jnhjgx3";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  doCheck = false; # Requires js2py

  meta = {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = https://github.com/lark-parser/lark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
