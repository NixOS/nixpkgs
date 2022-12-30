{ lib
, buildPythonPackage
, fastnumbers
, fetchPypi
, glibcLocales
, hypothesis
, pyicu
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "8.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V/hbcsaIsJ4FPNrDAt1bW1PfX3OuILSHT8v/2L94PRE=";
  };

  propagatedBuildInputs = [
    fastnumbers
    pyicu
  ];

  checkInputs = [
    glibcLocales
    hypothesis
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "natsort"
  ];

  meta = with lib; {
    description = "Natural sorting for Python";
    homepage = "https://github.com/SethMMorton/natsort";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
