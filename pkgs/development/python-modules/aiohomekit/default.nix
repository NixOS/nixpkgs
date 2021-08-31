{ lib
, buildPythonPackage
, commentjson
, cryptography
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonAtLeast
, zeroconf
}:

buildPythonPackage rec {
  pname = "aiohomekit";
  version = "0.6.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "16lfav83g12vzs3ssfva7chcqqb7xdx54djwfwyn9xcwfaa7cwhw";
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

  pythonImportsCheck = [ "aiohomekit" ];

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
