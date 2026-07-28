{
  lib,
  buildPythonPackage,
  fetchPypi,
  icmplib,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastdotcom";
  version = "0.0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "fastdotcom";
    inherit version;
    hash = "sha256-ozQ0d1CIIsMOdvK9UhRnr2c2fmIzkZcpjZrjZjfnknI=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
