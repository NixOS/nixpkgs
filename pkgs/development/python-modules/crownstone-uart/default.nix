{ lib
, crownstone-core
, buildPythonPackage
, pyserial
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crownstone-uart";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-uart";
    rev = version;
    sha256 = "0sdz131vmrfp6hrm9iwqw8mj9qazsxg7b85yadib1122w9f3b1zc";
  };

  propagatedBuildInputs = [
    crownstone-core
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "crownstone_uart"
  ];

  meta = with lib; {
    description = "Python module for communicating with Crownstone USB dongles";
    homepage = "https://github.com/crownstone/crownstone-lib-python-uart";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
