{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  version = "3.7.2";
  pname = "asgiref";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = "asgiref";
    rev = "refs/tags/${version}";
    hash = "sha256-VW1PBh6+nLMD7qxmL83ymuxCPYKVY3qGKsB7ZiMqMu8=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "asgiref" ];

  meta = with lib; {
    changelog = "https://github.com/django/asgiref/blob/${src.rev}/CHANGELOG.txt";
    description = "Reference ASGI adapters and channel layers";
    homepage = "https://github.com/django/asgiref";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
