{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, uritemplate
, pyjwt
, pytestCheckHook
, aiohttp
, httpx
, importlib-resources
, pytest-asyncio
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "gidgethub";
  version = "5.2.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w1m3aRlOcvmE0uMo3g7o64G3AjQrCkTcXOuskhBOz0s=";
  };

  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ];

  checkInputs = [
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
    description = "An async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
