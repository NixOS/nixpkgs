{
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "coapthon3";
  version = "1.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Tanganelli";
    repo = "CoAPthon3";
    rev = finalAttrs.version;
    hash = "sha256-9QApoPUu3XFZY/lgjAsf5r2StFiRtUd1UXWDrzYUh6w=";
  };

  propagatedBuildInputs = [ cachetools ];

  # tests take in the order of 10 minutes to execute and sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "coapthon" ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Python3 library to the CoAP protocol compliant with the RFC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ urbas ];
  };
})
