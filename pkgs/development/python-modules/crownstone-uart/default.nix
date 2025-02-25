{
  lib,
  crownstone-core,
  buildPythonPackage,
  pyserial,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "crownstone-uart";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-uart";
    rev = version;
    hash = "sha256-Sc6BCIRbf1+GraTScmV4EAgwtSE/JXNe0f2XhKyACIY=";
  };

  propagatedBuildInputs = [
    crownstone-core
    pyserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "crownstone_uart" ];

  meta = with lib; {
    description = "Python module for communicating with Crownstone USB dongles";
    homepage = "https://github.com/crownstone/crownstone-lib-python-uart";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
