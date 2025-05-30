{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  lib,
  libyaml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyyaml";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "pyyaml-ft";
    tag = "v${version}";
    hash = "sha256-hmHozVmqQuS+NqRN2SSEqNCemyKcBM19elhka4GykE0=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libyaml ];

  pythonImportsCheck = [ "yaml" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/Quansight-Labs/pyyaml-ft/blob/${src.tag}/CHANGES";
    description = "YAML parser and emitter for Python with support for free-threading";
    homepage = "https://github.com/Quansight-Labs/pyyaml-ft";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
