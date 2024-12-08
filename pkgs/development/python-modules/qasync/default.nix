{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "qasync";
  version = "0.27.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CabbageDevelopment";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oXzwilhJ1PhodQpOZjnV9gFuoDy/zXWva9LhhK3T00g=";
  };

  postPatch = ''
    rm qasync/_windows.py # Ignoring it is not taking effect and it will not be used on Linux
  '';

  buildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pyqt5 ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "qasync" ];

  disabledTestPaths = [ "tests/test_qeventloop.py" ];

  meta = {
    description = "Allows coroutines to be used in PyQt/PySide applications by providing an implementation of the PEP 3156 event-loop";
    homepage = "https://github.com/CabbageDevelopment/qasync";
    license = [ lib.licenses.bsd2 ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
