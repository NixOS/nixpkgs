{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  httpcore,
  httpx,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  starlette,
  trio,
}:

buildPythonPackage rec {
  pname = "respx";
  version = "0.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = "respx";
    rev = version;
    hash = "sha256-sBb9HPvX+AKJUMWBME381F2amYdQmBiM8OguGW3lFG0=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    httpcore
    httpx
    flask
    pytest-asyncio
    pytestCheckHook
    starlette
    trio
  ];

  disabledTests = [ "test_pass_through" ];

  pythonImportsCheck = [ "respx" ];

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
    changelog = "https://github.com/lundberg/respx/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
