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
  numpy,
  pytestCheckHook,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "construct-typing";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timrid";
    repo = "construct-typing";
    tag = "v${version}";
    hash = "sha256-zXpxu+VUcepEoAPLQnSlMCZkt8fDsMCLS0HBKhaYD20=";
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
    numpy
    pytestCheckHook
    ruamel-yaml
  ];

  disabledTests =
    [
      # tests fail with construct>=2.10.70
      "test_bitsinteger"
      "test_bytesinteger"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/timrid/construct-typing/issues/31
      "test_tenum_docstring"
      "test_tenum_flags_docstring"
    ];

  meta = {
    changelog = "https://github.com/timrid/construct-typing/releases/tag/v${version}";
    description = "Extension for the python package 'construct' that adds typing features";
    homepage = "https://github.com/timrid/construct-typing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
