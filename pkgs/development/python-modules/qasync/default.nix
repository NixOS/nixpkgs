{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, diff-cover
, pytest-mock
, pytestCheckHook
, pyqt5
, pip
, virtualenv
}:

buildPythonPackage rec {
  pname = "qasync";
  version = "0.24.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5YPRw64g/RLpCN7jWMUncJtIDnjVf7cu5XqUCXMH2Vk=";
  };

  nativeBuildInputs = [  ];

  propagatedBuildInput = [
    pip
    pyqt5
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
