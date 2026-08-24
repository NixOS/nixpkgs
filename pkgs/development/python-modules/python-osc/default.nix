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
  version = "1.10.2";
  pyproject = true;

  src = fetchPypi {
    pname = "python_osc";
    inherit version;
    hash = "sha256-cyVI9PRn3an4kKaws7+whasRf0vTikWljSyg871qVG0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pythonosc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Open Sound Control server and client in pure python";
    homepage = "https://github.com/attwad/python-osc";
    changelog = "https://github.com/attwad/python-osc/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ anirrudh ];
  };
}
