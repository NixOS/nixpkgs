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
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D2NCTn1Q3/AknmEAAOZO4d7i2mpM/kMlt94RaLmmnjM=";
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

