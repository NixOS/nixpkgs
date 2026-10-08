{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pydantic-xml,
  pydantic,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-datafiles,
  pytest-httpx,
  pytest-vcr,
  pytestCheckHook,
  responses,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "restfly";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stevemcgrath";
    repo = "restfly";
    tag = finalAttrs.version;
    hash = "sha256-RE1k0orzDAqGSRfGaMrZ2gKXKVYt/lIYm+fn5HP3POA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    pydantic
    pydantic-xml
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-datafiles
    pytest-httpx
    pytest-vcr
    pytestCheckHook
    responses
  ];

  disabledTests = [
    # Test requires network access
    "test_session_ssl_error"
  ];

  pythonImportsCheck = [ "restfly" ];

  meta = {
    description = "Python RESTfly API Library Framework";
    homepage = "https://github.com/stevemcgrath/restfly";
    changelog = "https://github.com/librestfly/restfly/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
