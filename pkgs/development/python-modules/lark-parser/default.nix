{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "0kaiw8zzzcp92p6mzm9zkyhv578p0x4lzjsyl8b4rnsafplmbscs";
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
