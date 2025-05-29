{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  requests,
  pyyaml,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  uvloop,
  hypercorn,
  starlette,
  pydantic,
}:

buildPythonPackage rec {
  pname = "openapi3";
  version = "1.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";
  src = fetchFromGitHub {
    owner = "Dorthu";
    repo = "openapi3";
    rev = version;
    hash = "sha256-Crn+nRbptRycnWJzH8Tm/BBLcBSRCcNtLX8NoKnSDdA=";
  };

  # pydantic==1.10.2 only affects checks
  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ setuptools ];

  dependencies = [
    requests
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pydantic
    uvloop
    hypercorn
    starlette
  ];

  disabledTestPaths = [
    # tests old fastapi behaviour
    "tests/fastapi_test.py"
  ];

  pythonImportsCheck = [ "openapi3" ];

  meta = with lib; {
    changelog = "https://github.com/Dorthu/openapi3/releases/tag/${version}";
    description = "Python3 OpenAPI 3 Spec Parser";
    homepage = "https://github.com/Dorthu/openapi3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
