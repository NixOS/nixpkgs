{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser"; # PyPI name
  version = "2017-12-10";

  src = fetchFromGitHub {
    owner = "erezsh";
    repo = "lark";
    rev = "852607b978584ecdec68ac115dd8554cdb0a2305";
    sha256 = "1clzmvbp1b4zamcm6ldak0hkw46n3lhw4b28qq9xdl0n4va6zig7";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  doCheck = false; # Requires js2py

  meta = {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = https://github.com/erezsh/lark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
