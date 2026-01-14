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
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ni";
    repo = "hightime";
    rev = "v${version}";
    hash = "sha256-P/ZP5smKyNg18YGYWpm/57YGFY3MrX1UIVDU5RsF+rA=";
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
    changelog = "https://github.com/ni/hightime/releases/tag/v${version}";
    description = "Hightime Python API";
    homepage = "https://github.com/ni/hightime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fsagbuya ];
  };
}
