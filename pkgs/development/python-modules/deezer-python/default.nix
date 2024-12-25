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
  version = "7.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = "deezer-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-3TYgOa8NWGhkVIT5HkDdpHGyj7FzP8n02a36KHW6IC4=";
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
