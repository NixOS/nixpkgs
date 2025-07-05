{
  lib,
  buildPythonPackage,
  fetchPypi,
  icmplib,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "fastdotcom";
  version = "0.0.6";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "fastdotcom";
    inherit version;
    hash = "sha256-DAj5Bp8Vlg/NQSnz0yF/nHlIO7kStHlBABwvTWHVsIo=";
  };

  propagatedBuildInputs = [
    icmplib
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "fastdotcom" ];

  meta = {
    description = "Python API for testing internet speed on Fast.com";
    homepage = "https://github.com/nkgilley/fast.com";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
