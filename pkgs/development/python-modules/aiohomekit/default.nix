{ lib
, buildPythonPackage
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
  version = "0.2.67";
  format = "pyproject";
  disabled = pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "Jc2k";
    repo = pname;
    rev = version;
    sha256 = "04421p0dq7xh7rhx8ip177g2b91lhlc2yziqxbs9yxd1qyzwiqj1";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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
