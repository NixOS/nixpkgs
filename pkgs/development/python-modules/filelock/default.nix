{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nNVAqTUuQyxyRqSP5OhxKxCssd8q0fMOjAcLgq4f7YU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/benediktschmitt/py-filelock";
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
