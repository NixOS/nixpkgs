{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  tomli-w,
  types-pyyaml,
  types-toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "responses";
  version = "0.25.7";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "responses";
    tag = version;
    hash = "sha256-eiJwu0sRtr3S4yAnbsIak7g03CNqOTS16rNXoXRQumA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    requests
    types-pyyaml
    types-toml
    urllib3
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
    tomli-w
  ];

  pythonImportsCheck = [ "responses" ];

  meta = {
    description = "Python module for mocking out the requests Python library";
    homepage = "https://github.com/getsentry/responses";
    changelog = "https://github.com/getsentry/responses/blob/${src.tag}/CHANGES";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
