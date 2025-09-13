{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "afsapi";
  version = "0.2.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "python-afsapi";
    tag = version;
    hash = "sha256-eE5BsXNtSU6YUhRn4/SKpMrqaYf8tyfLKdxxGOmNJ9I=";
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

  meta = with lib; {
    description = "Python implementation of the Frontier Silicon API";
    homepage = "https://github.com/wlcrs/python-afsapi";
    changelog = "https://github.com/wlcrs/python-afsapi/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
