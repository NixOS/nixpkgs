{ lib
, crownstone-core
, buildPythonPackage
, pyserial
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "crownstone-uart";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-uart";
    rev = version;
    sha256 = "sha256-temf+uvGWMMtnhBpbYtTj6OzKqo3Xaa11Q2VX2+HTZc=";
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
