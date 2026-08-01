{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonAtLeast,
  construct,
  typing-extensions,
  arrow,
  cloudpickle,
  cryptography,
  numpy,
  pytestCheckHook,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "construct-typing";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timrid";
    repo = "construct-typing";
    tag = "v${version}";
    hash = "sha256-yKk0KmvXShKLG3wxGGWZUydro34qHx3JriwPsF4qaWA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "construct" ];

  dependencies = [
    construct
    typing-extensions
  ];

  pythonImportsCheck = [
    "construct-stubs"
    "construct_typed"
  ];

  nativeCheckInputs = [
    arrow
    cloudpickle
    cryptography
    numpy
    pytestCheckHook
    ruamel-yaml
  ];

  meta = {
    changelog = "https://github.com/timrid/construct-typing/releases/tag/v${version}";
    description = "Extension for the python package 'construct' that adds typing features";
    homepage = "https://github.com/timrid/construct-typing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
