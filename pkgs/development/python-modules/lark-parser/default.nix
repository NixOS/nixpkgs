{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "0mf10xm9blqik8mwrpw0r07vqlk2y4r98yqvk1sq849zqlxmqpsr";
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
