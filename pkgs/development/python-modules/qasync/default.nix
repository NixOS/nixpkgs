{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt-builder
, setuptools
, setuptools-scm
, pyqt5
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qasync";
  version = "0.19.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "CabbageDevelopment";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xGAUAyOq+ELwzMGbLLmXijxLG8pv4a6tPvfAVOt1YwU=";
  };

  buildInputs = [ pyqt-builder ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ pyqt5 ];

  pythonImportsCheck = [ "qasync" ];

  doCheck = true;

  checkInputs = [
    pytestCheckHook
  ];

  # FIXME Cannot get `test_qeventloop.py` to work, perhaps due to bad OS detection in test
  # https://github.com/CabbageDevelopment/qasync/blob/master/tests/test_qeventloop.py
  pytestFlagsArray = [
    "tests/test_qthreadexec.py"
  ];

  meta = with lib; {
    description = "Allows coroutines to be used in PyQt/PySide applications by providing an implementation \
      of the PEP 3156 event-loop";
    homepage = "https://github.com/CabbageDevelopment/qasync";
    changelog = "https://github.com/CabbageDevelopment/qasync/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ totoroot ];
  };
}
