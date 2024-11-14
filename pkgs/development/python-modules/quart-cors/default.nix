{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # propagates
  quart,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "quart-cors";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-cors";
    rev = "refs/tags/${version}";
    hash = "sha256-qUzs0CTZHf3fGADBXPkd3CjZ6dnz1t3cTxflMErvz/k=";
  };

  build-system = [ poetry-core ];

  dependencies = [ quart ] ++ lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  pythonImportsCheck = [ "quart_cors" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  meta = with lib; {
    description = "Quart-CORS is an extension for Quart to enable and control Cross Origin Resource Sharing, CORS";
    homepage = "https://github.com/pgjones/quart-cors/";
    changelog = "https://github.com/pgjones/quart-cors/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
