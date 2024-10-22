{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiocurrencylayer";
  version = "1.0.6";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "aiocurrencylayer";
    rev = "refs/tags/${version}";
    hash = "sha256-VOzgWN+dDPaGEcahFPSWjBR989b9eNkx4zcnI9o2Xiw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiocurrencylayer" ];

  meta = with lib; {
    description = "Python API for interacting with currencylayer";
    homepage = "https://github.com/home-assistant-ecosystem/aiocurrencylayer";
    changelog = "https://github.com/home-assistant-ecosystem/aiocurrencylayer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
