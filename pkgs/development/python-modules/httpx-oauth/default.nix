{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch,
  hatch-regex-commit,
  httpx,
  fastapi,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  respx,
}:

buildPythonPackage rec {
  pname = "httpx-oauth";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "httpx-oauth";
    rev = "v${version}";
    hash = "sha256-f3X3kSw7elTScCA3bNggwXyyHORre6Xzup/D0kgn4DQ=";
  };

  build-system = [
    hatch
    hatch-regex-commit
  ];

  dependencies = [
    httpx
  ];

  nativeCheckInputs = [
    fastapi
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    respx
  ];

  meta = with lib; {
    description = "Async OAuth client using HTTPX";
    homepage = "https://github.com/frankie567/httpx-oauth";
    changelog = "https://github.com/frankie567/httpx-oauth/releases/tag/v${version}";
    license = licenses.mit;
  };
}
