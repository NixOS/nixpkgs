{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "3.9.1";
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    tag = version;
    hash = "sha256-VD8OQP+Xq3JpUz3fZRl6g+SL7mGZjeHjOU9Cd+scYzc=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_multiprocessing" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    changelog = "https://github.com/django/asgiref/blob/${src.rev}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
