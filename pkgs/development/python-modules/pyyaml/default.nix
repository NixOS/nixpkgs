{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  libyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyyaml";
  version = "6.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yaml";
    repo = "pyyaml";
    tag = version;
    hash = "sha256-7EKChsoRuDFyTlemqBNorX6IgoY4wD5n/4QzEMatL1o=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libyaml ];

  pythonImportsCheck = [ "yaml" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/yaml/pyyaml/blob/${src.rev}/CHANGES";
    description = "Next generation YAML parser and emitter for Python";
    homepage = "https://github.com/yaml/pyyaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
