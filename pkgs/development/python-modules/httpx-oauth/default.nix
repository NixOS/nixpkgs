{
  lib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  hatchling,
  hatch-regex-commit,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "httpx-oauth";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "httpx-oauth";
    tag = "v${version}";
    hash = "sha256-KM+GaBC3jOhMsTVdUixsEjm47j28qeFmFKbI7fnVSG4=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    fastapi
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "httpx_oauth" ];

  meta = with lib; {
    description = "Async OAuth client using HTTPX";
    homepage = "https://github.com/frankie567/httpx-oauth";
    changelog = "https://github.com/frankie567/httpx-oauth/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
