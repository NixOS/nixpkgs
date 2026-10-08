{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jmespath";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmespath";
    repo = "jmespath.py";
    tag = finalAttrs.version;
    hash = "sha256-DtRMWKE1LeD+NAmMJOISfBo5w9HJW7XFeQp7A3NjkjE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  meta = {
    homepage = "https://github.com/jmespath/jmespath.py";
    changelog = "https://github.com/jmespath/jmespath.py/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    mainProgram = "jp.py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
