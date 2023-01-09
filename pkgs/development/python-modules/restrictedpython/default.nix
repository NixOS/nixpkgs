{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "5.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "RestrictedPython";
    inherit version;
    hash = "sha256-Y02h9sXBIqJi9DOwg+49F6mgOfjxs3eFl++0dGHNNhs=";
  };

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [
    "RestrictedPython"
  ];

  meta = with lib; {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    changelog = "https://github.com/zopefoundation/RestrictedPython/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ juaningan ];
  };
}
