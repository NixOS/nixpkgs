{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "afsapi";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "python-afsapi";
    tag = version;
    hash = "sha256-WkkRsXRJ4i3lUn3X94YX7ZqfaKE2GgrBycbflnnlC74=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  doCheck = false; # Failed: async def functions are not natively supported.

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  enabledTestPaths = [ "async_tests.py" ];

  pythonImportsCheck = [ "afsapi" ];

  meta = {
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/wlcrs/python-afsapi";
    changelog = "https://github.com/wlcrs/python-afsapi/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
