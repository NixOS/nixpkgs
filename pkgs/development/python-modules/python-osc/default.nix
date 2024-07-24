{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-osc";
  version = "1.8.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pc4bpWyNgt9Ryz8pRrXdM6cFInkazEuFZOYtKyCtnKo=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pythonosc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    changelog = "https://github.com/attwad/python-osc/blob/v${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ anirrudh ];
  };
}
