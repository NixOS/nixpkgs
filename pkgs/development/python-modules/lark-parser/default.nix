{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser"; # PyPI name
  version = "2017-12-18";

  src = fetchFromGitHub {
    owner = "erezsh";
    repo = "lark";
    rev = "9d6cde9b1ba971f02ea8106fa3b71a934e83d6fa";
    sha256 = "0nv6nxd8wx9dwhn37m94fkc10gknckrjs1hzajxygla3dpql455j";
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
