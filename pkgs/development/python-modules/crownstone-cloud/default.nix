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
  version = "1.4.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-cloud";
    rev = "v${version}";
    sha256 = "1a8bkqkrc7iyggr5rr20qdqg67sycdx2d94dd1ylkmr7627r34ys";
  };

  propagatedBuildInputs = [
    aiohttp
    asynctest
    certifi
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "codecov>=2.1.10" ""
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
