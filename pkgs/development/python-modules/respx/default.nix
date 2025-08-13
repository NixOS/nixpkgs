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
  pythonOlder,
  setuptools,
  starlette,
  trio,
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = "respx";
    tag = version;
    hash = "sha256-T3DLNXJykSF/HXjlmQdJ2CG4d+U1eTa+XWcgtT3dhl4=";
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

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    changelog = "https://github.com/lundberg/respx/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
