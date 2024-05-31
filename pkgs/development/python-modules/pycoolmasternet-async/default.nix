{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    rev = "v${version}";
    hash = "sha256-7RYKZWs8SCXCBgjbiTLSRUPujeraxiOE6MHENPmhimg=";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pycoolmasternet_async" ];

  meta = with lib; {
    description = "Python library to control CoolMasterNet HVAC bridges over asyncio";
    homepage = "https://github.com/OnFreund/pycoolmasternet-async";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
