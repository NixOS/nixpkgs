{ lib
, buildPythonPackage
, fetchFromGitHub
, pytools
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "cgen";
  version = "2020.1";

  src = fetchFromGitHub {
     owner = "inducer";
     repo = "cgen";
     rev = "v2020.1";
     sha256 = "0hpm5j7kh5xqcn5x2p1ykyhd6aa3cysj4y0qg6hb6gg00gjrwzpd";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    pytools
    numpy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "C/C++ source generation from an AST";
    homepage = "https://github.com/inducer/cgen";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
