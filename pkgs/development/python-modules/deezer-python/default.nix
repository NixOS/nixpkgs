{
  lib,
  buildPythonPackage,
  environs,
  fetchFromGitHub,
  httpx,
  setuptools,
  pytest-cov-stub,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  tornado,
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "7.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = "deezer-python";
    tag = "v${version}";
    hash = "sha256-j7FiZJX2YIYs03bKKu2e+ByElp5oYpmpUheVr8BVXZo=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    environs
    pytest-cov-stub
    pytest-mock
    pytest-vcr
    pytestCheckHook
    tornado
  ];

  pythonImportsCheck = [ "deezer" ];

  disabledTests = [
    # JSONDecodeError issue
    "test_get_user_flow"
    "test_with_language_header"
  ];

  meta = with lib; {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    changelog = "https://github.com/browniebroke/deezer-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
