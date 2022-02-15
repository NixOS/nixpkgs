{ lib
, buildPythonPackage
, commentjson
, cryptography
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "aiohomekit";
  version = "0.7.14";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    hash = "sha256-0j0qXIY0E8BobqjYIWGmPlDivkD/FAMJMQHC9GKy5NA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    commentjson
    cryptography
    zeroconf
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_ip_pairing.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_remove_pairing"
    "test_find_ip_by_device_id"
    "test_pair"
    "test_identify"
    "test_get_accessories"
    "test_get_characteristic"
    "test_put_characteristic"
    "test_list_pairings"
  ];

  pythonImportsCheck = [
    "aiohomekit"
  ];

  meta = with lib; {
    description = "Python module that implements the HomeKit protocol";
    longDescription = ''
      This Python library implements the HomeKit protocol for controlling
      Homekit accessories.
    '';
    homepage = "https://github.com/Jc2k/aiohomekit";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
