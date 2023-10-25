{ lib
, aiomisc
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "caio";
  version = "0.9.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-uMq/3yWP9OwaVxixGAFCLMsDPoJhmIuG0I7hO7AnIOk=";
  };

  nativeCheckInputs = [
    aiomisc
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "caio"
  ];

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/caio";
    changelog = "https://github.com/mosquito/caio/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
