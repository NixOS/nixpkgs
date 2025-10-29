{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cython,
  setuptools,
  libyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyyaml";
  version = "6.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    tag = version;
    hash = "sha256-jUooIBp80cLxvdU/zLF0X8Yjrf0Yp9peYeiFjuV8AHA=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libyaml ];

  pythonImportsCheck = [ "yaml" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/yaml/pyyaml/blob/${src.rev}/CHANGES";
    description = "Next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
