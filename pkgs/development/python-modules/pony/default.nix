{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pony";
  version = "0.7.18";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "ponyorm";
    repo = "pony";
    rev = "refs/tags/v${version}";
    hash = "sha256-2qGkHPBbfFrjJatKVa44bDbn/i3/YH/8LWd8CXyFRqo=";
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

  meta = with lib; {
    description = "Library for advanced object-relational mapping";
    homepage = "https://ponyorm.org/";
    changelog = "https://github.com/ponyorm/pony/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      d-goldin
      xvapx
    ];
  };
}
