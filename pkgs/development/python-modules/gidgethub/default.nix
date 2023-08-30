{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, flit-core
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
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ns59N/vOuBm4BWDn7Vj5NuSKZdN+xfVtt5FFFWtCaiU=";
  };

  patches = [
    # https://github.com/gidgethub/gidgethub/pull/205
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/gidgethub/gidgethub/commit/35048fa04ec80fe18e80c34dc0c1978a97cfa700.patch";
      hash = "sha256-z+i17Nsh1EFAhrk2dVed6bi22AOUpmiZBE7PKM/fGaU=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

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
    maintainers = [ ];
  };
}
