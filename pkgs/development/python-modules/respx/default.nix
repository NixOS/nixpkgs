{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  httpcore,
  httpx,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  starlette,
  trio,
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = "respx";
    tag = version;
    hash = "sha256-Fz3CS9rIm+H6axVIRErlFTTDgtAcTmGj4/wabLxDV2I=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    httpcore
    httpx
    flask
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    starlette
    trio
  ];

  disabledTests = [ "test_pass_through" ];

  pythonImportsCheck = [ "respx" ];

  meta = {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    changelog = "https://github.com/lundberg/respx/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
