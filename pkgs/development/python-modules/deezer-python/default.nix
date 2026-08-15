{
  lib,
  buildPythonPackage,
  environs,
  fetchFromGitHub,
  httpx,
  setuptools,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-vcr,
  pytestCheckHook,
  tornado,
}:

buildPythonPackage (finalAttrs: {
  pname = "deezer-python";
  version = "7.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = "deezer-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9zq96imTNWF43DQoTkXCgNusfdVDNOKEN5ELS6R5YU=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    environs
    pytest-asyncio
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

  meta = {
    description = "Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    changelog = "https://github.com/browniebroke/deezer-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
