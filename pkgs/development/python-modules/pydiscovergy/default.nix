{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpx,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "pydiscovergy";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jpbede";
    repo = "pydiscovergy";
    tag = "v${version}";
    hash = "sha256-OrMuMGN1zB4q6t4fWyZeQ9WRmNZHFyq+wIRq1kG2N30=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    authlib
    httpx
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-httpx
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pydiscovergy" ];

  meta = with lib; {
    description = "Library for interacting with the Discovergy API";
    homepage = "https://github.com/jpbede/pydiscovergy";
    changelog = "https://github.com/jpbede/pydiscovergy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
