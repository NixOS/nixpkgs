{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "docker-pycreds";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bOMnC8r0BMxMPifktscNNSHeroL7UIdnhw/b93LVhNQ=";
  };

  # require docker-credential-helpers binaries
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Python bindings for the docker credentials store API";
    homepage = "https://github.com/shin-/dockerpy-creds";
    license = licenses.asl20;
  };
}
