{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pythonOlder
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, yarl
}:

buildPythonPackage rec {
  pname = "elmax";
  version = "0.1.5";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-elmax";
    rev = version;
    hash = "sha256-EcYEpYv+EwwEfW8Sy7aQjFAPpmsA6qVbmlwrPdxdnEw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    httpx
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "elmax" ];

  meta = with lib; {
    description = "Python API client for the Elmax Cloud services";
    homepage = "https://github.com/home-assistant-ecosystem/python-elmax";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
