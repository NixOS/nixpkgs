{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "flatten-json";
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "amirziai";
    repo = "flatten";
    rev = "v${version}";
    hash = "sha256-ViOLbfJtFWkDQ5cGNYerTk2BqVg5f5B3hZ96t0uvhpk=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flatten_json" ];

  meta = {
    description = "Flatten JSON in Python";
    homepage = "https://github.com/amirziai/flatten";
    changelog = "https://github.com/amirziai/flatten/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
