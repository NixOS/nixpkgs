{
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  isPy27,
  lib,
}:

buildPythonPackage rec {
  pname = "coapthon3";
  version = "1.0.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "Tanganelli";
    repo = "CoAPthon3";
    rev = version;
    hash = "sha256-9QApoPUu3XFZY/lgjAsf5r2StFiRtUd1UXWDrzYUh6w=";
  };

  propagatedBuildInputs = [ cachetools ];

  # tests take in the order of 10 minutes to execute and sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "coapthon" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Python3 library to the CoAP protocol compliant with the RFC";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
