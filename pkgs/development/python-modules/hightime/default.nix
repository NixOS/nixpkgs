{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "hightime";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "hightime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5WEr2tOxQap+otV8DCdIi3MkfHol4TU4qZXf4u2EQhY=";
  };

  build-system = [
    poetry-core
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
    changelog = "https://github.com/ni/hightime/releases/tag/v${finalAttrs.version}";
    description = "Hightime Python API";
    homepage = "https://github.com/ni/hightime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
})
