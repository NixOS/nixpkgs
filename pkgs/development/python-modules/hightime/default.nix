{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "hightime";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "hightime";
    tag = "v${version}";
    hash = "sha256-5WEr2tOxQap+otV8DCdIi3MkfHol4TU4qZXf4u2EQhY=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  # Test incompatible with datetime's integer type requirements
  disabledTests = [
    "test_datetime_arg_wrong_value"
  ];

  pythonImportsCheck = [ "hightime" ];

  meta = {
    changelog = "https://github.com/ni/hightime/releases/tag/${src.tag}";
    description = "Hightime Python API";
    homepage = "https://github.com/ni/hightime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
