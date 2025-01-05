{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pdm-backend,

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
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "quart-cors";
    tag = version;
    hash = "sha256-f+l+j0bjzi5FTwJzdXNyCgh3uT4zldpg22ZOgW1Wub4=";
  };

  build-system = [ pdm-backend ];

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
