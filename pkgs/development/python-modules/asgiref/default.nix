{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  version = "3.11.0";
  pname = "asgiref";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    tag = version;
    hash = "sha256-2ZaUIWGF5cQVNj95b7WiKGsn2wYsoJmJ/CfPhIEZdjc=";
  };

  propagatedBuildInputs = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_multiprocessing" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = {
    changelog = "https://github.com/django/asgiref/blob/${src.tag}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
