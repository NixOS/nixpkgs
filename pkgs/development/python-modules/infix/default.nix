{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "infix";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1bfdcf875bc072f41e426d0673f2e3017750743bb90cc725fffb292eb09648c";
  };

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/borntyping/python-infix";
    description = "A decorator that allows functions to be used as infix functions";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}

