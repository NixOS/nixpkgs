{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, diff-cover
, pytest-mock
, pytestCheckHook
, pip
, virtualenv
}:

buildPythonPackage rec {
  pname = "qasync";
  version = "0.24.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-brmQtp304VutiZ6oaNxGVyw/dTOXNWY7gd55sG8X65o=";
  };

  nativeBuildInputs = [  ];

  propagatedBuildInput = [
    pip
  ];

  nativeCheckInputs = [
    diff-cover
    pytest-mock
    pytestCheckHook
    virtualenv
  ];

  pythonImportsCheck = [
    "qasync"
  ];

  meta = with lib; {
    description = "qasync allows coroutines to be used in PyQt/PySide applications by providing an implementation of the PEP 3156 event-loop.";
    homepage = "https://pypi.org/project/qasync/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
