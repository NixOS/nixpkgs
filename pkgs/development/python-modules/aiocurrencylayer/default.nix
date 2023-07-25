{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiocurrencylayer";
  version = "1.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-468OBQV7ISnPRUfi/CM3dCh1ez0jwSVnM6DduPvAgPI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiocurrencylayer"
  ];

  meta = with lib; {
    description = "Python API for interacting with currencylayer";
    homepage = "https://github.com/home-assistant-ecosystem/aiocurrencylayer";
    changelog = "https://github.com/home-assistant-ecosystem/aiocurrencylayer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
