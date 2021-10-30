{ lib
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, certifi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "crownstone-cloud";
  version = "1.4.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-cloud";
    rev = version;
    sha256 = "sha256-iHn4g52/QM0TS/flKkcFrX6IFrCjiXUxcjVLHNg6tVo=";
  };

  propagatedBuildInputs = [
    aiohttp
    asynctest
    certifi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/crownstone/crownstone-lib-python-cloud/issues/1
    "test_data_structure"
  ];

  postPatch = ''
    sed -i '/codecov/d' requirements.txt
  '';

  pythonImportsCheck = [
    "crownstone_cloud"
  ];

  meta = with lib; {
    description = "Python module for communicating with Crownstone Cloud and devices";
    homepage = "https://github.com/crownstone/crownstone-lib-python-cloud";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
