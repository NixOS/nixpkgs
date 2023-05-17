{ lib
, aiohttp
, async_generator
, buildPythonPackage
, fetchFromGitHub
, httpx
, pytest
, pytestCheckHook
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "yunstanford";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-82Xq/jyxTXyZVHqn7G+S9K++InDdORCO9oFqgaIgY7s=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    async_generator
    httpx
    pytest
    websockets
  ];

  nativeCheckInputs = [
    sanic
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_sanic"
  ];

  meta = with lib; {
    description = "A pytest plugin for Sanic";
    homepage = "https://github.com/yunstanford/pytest-sanic/";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
    broken = true; # 2021-11-04
  };
}
