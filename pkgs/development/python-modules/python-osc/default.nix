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
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_osc";
    inherit version;
    hash = "sha256-q1D2axoZ79W/9yLyarZFDfGc3YS6ho8IyaM+fHhRRFY=";
  };

  build-system = [ setuptools ];

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
