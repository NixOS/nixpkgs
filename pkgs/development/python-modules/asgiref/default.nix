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
  version = "3.11.1";
  pname = "asgiref";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    tag = finalAttrs.version;
    hash = "sha256-Mhnaowgv5a+O2hN0ZSdtdhCBQx8HoKSwtRC3gHodgKY=";
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
