{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, backoff
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aiomodernforms";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "wonderslug";
    repo = "aiomodernforms";
    rev = "v${version}";
    hash = "sha256-Vx51WBjjNPIfLlwMnAuwHnGNljhnjKkU0tWB9M9rjsw=";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomodernforms" ];

  meta = with lib; {
    description = "Asynchronous Python client for Modern Forms fans";
    homepage = "https://github.com/wonderslug/aiomodernforms";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
