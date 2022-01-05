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
  version = "7.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7054b4e1f47365f141602a742685165a552291b643a214652d0dd9d6cea58d1";
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
