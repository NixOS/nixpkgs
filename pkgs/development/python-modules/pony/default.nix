{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.19";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "ponyorm";
    repo = "pony";
    tag = "v${version}";
    hash = "sha256-fYzwdHRB9QrIJPEk8dqtPggSnJeugDyC9zQSM6u3rN0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests are outdated
    "test_method"
    # https://github.com/ponyorm/pony/issues/704
    "test_composite_param"
    "test_equal_json"
    "test_equal_list"
    "test_len"
    "test_ne"
    "test_nonzero"
    "test_query"
  ];

  pythonImportsCheck = [ "pony" ];

  meta = {
    description = "Library for advanced object-relational mapping";
    homepage = "https://ponyorm.org/";
    changelog = "https://github.com/ponyorm/pony/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      d-goldin
      xvapx
    ];
  };
}
