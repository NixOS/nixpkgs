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
  version = "8.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x8Hz8nw3Vxmk38qzU5Cf458mwgMqBiqMgMyETqrKBEU=";
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
