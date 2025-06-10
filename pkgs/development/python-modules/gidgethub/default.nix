{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit,
  uritemplate,
  pyjwt,
  pytestCheckHook,
  aiohttp,
  httpx,
  importlib-resources,
  pytest-asyncio,
  pytest-tornasync,
}:

buildPythonPackage rec {
  pname = "gidgethub";
  version = "5.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dHDXcj18F0NHGi1i55yHUvuhKxwJcuS61XJSM4pQHb0=";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp
    httpx
    importlib-resources
    pytest-asyncio
    pytest-tornasync
  ];

  disabledTests = [
    # Require internet connection
    "test__request"
    "test_get"
  ];

  meta = with lib; {
    description = "Async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
