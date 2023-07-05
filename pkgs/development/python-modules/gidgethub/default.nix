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
  version = "5.3.0";
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ns59N/vOuBm4BWDn7Vj5NuSKZdN+xfVtt5FFFWtCaiU=";
  };

  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ]
  ++ pyjwt.optional-dependencies.crypto;

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
    description = "An async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
