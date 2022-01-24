{ lib
, buildPythonPackage
, fastnumbers
, fetchPypi
, glibcLocales
, hypothesis
, PyICU
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "natsort";
  version = "8.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/rh+DOHcH48/IeGKhSFseQ50bXal/2iJVjOUYF9QSis=";
  };

  propagatedBuildInputs = [
    fastnumbers
    PyICU
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
