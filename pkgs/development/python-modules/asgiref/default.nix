{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  version = "3.13.0";
  pname = "asgiref";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    tag = finalAttrs.version;
    hash = "sha256-Qsg0PwD6XYZkcBIcnwEjPC+2fCro35MQyXMPWm64014=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_multiprocessing" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = {
    changelog = "https://github.com/django/asgiref/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
