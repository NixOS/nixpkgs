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
  version = "0.7.17";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-vgRiqA3xNvuw3nIzl45RXdmcbDW6OTxvReSH5SVcNEs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    commentjson
    cryptography
    zeroconf
  ];

  doCheck = lib.versionAtLeast pytest-aiohttp.version "1.0.0";

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_ip_pairing.py"
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
