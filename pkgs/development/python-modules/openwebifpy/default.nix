{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, yarl
}:

buildPythonPackage rec {
  pname = "openwebifpy";
  version = "4.0.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mGCi3nFnyzA+yKD5qtpErXYjOA6liZRiy7qJTbTGGnQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openwebif"
  ];

  disabledTests = [
    # https://github.com/autinerd/openwebifpy/issues/1
    "test_get_picon_name"
  ];

  meta = with lib; {
    description = "Provides a python interface to interact with a device running OpenWebIf";
    homepage = "https://github.com/autinerd/openwebifpy";
    changelog = "https://github.com/autinerd/openwebifpy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

