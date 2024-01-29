{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, certifi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "crownstone-cloud";
  version = "1.4.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-cloud";
    rev = "refs/tags/${version}";
    hash = "sha256-CS1zeQiWPnsGCWixCsN9sz08mPORW5sVqIpSFPh0Qt0=";
  };

  patches = [
    # Remove asynctest, https://github.com/crownstone/crownstone-lib-python-cloud/pull/4
    (fetchpatch {
      name = "remove-asynctest.patch";
      url = "https://github.com/crownstone/crownstone-lib-python-cloud/commit/7f22c9b284bf8d7f6f43e205816787dd3bb37e78.patch";
      hash = "sha256-LS1O9LVB14WyBXfuHf/bs1juJ59zWhJ8pL4aGtVrTG8=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    certifi
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
