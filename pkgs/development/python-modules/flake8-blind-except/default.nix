{ lib
, fetchPypi
, buildPythonPackage
, pycodestyle
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flake8-blind-except";
  version = "0.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8lpXWp3LPus8dgv5wi22C4taIxICJO0fqppD913X3RY=";
  };

  propagatedBuildInputs = [
    pycodestyle
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "flake8_blind_except"
  ];

  meta = with lib; {
    description = "A flake8 extension that checks for blind except: statements";
    homepage = "https://github.com/elijahandrews/flake8-blind-except";
    license = licenses.mit;
    maintainers = with maintainers; [ johbo ];
  };
}
