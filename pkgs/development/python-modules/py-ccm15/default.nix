{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  httpx,
  xmltodict,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "py-ccm15";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ocalvo";
    repo = "py-ccm15";
    # Upstream does not have a tag for this release and this is the exact release commit
    # Therefore it should not be marked unstable
    # upstream issue: https://github.com/ocalvo/py-ccm15/issues/10
    tag = "v${version}";
    hash = "sha256-QfitJzCFk0gnlcCvvKzuI4fS1lVm79q4xaDZFKKt458=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    xmltodict
    aiohttp
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # tests use outdated function signature
    "test_async_set_state"
  ];

  pythonImportsCheck = [ "ccm15" ];

  meta = {
    changelog = "https://github.com/ocalvo/py-ccm15/releases/tag/${src.tag}";
    description = "Python Library to access a Midea CCM15 data converter";
    homepage = "https://github.com/ocalvo/py-ccm15";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
