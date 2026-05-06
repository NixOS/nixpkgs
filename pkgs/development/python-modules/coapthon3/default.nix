{
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "coapthon3";
  version = "1.01";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Tanganelli";
    repo = "CoAPthon3";
    rev = version;
    hash = "sha256-t49e3vJMIkq8Vs5AFABcZgr3iE8sWS7QEEfz21vv5NY=";
  };

  propagatedBuildInputs = [ cachetools ];

  # tests take in the order of 10 minutes to execute and sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "coapthon" ];

  meta = {
    inherit (src.meta) homepage;
    description = "Python3 library to the CoAP protocol compliant with the RFC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
}
