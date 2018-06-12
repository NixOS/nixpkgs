{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "docker-pycreds";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b0e956c8d206f832b06aa93a710ba2c3bcbacb5a314449c040b0b814355bbff";
  };

  # require docker-credential-helpers binaries
  doCheck = false;

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Python bindings for the docker credentials store API.";
    homepage = https://github.com/shin-/dockerpy-creds;
    license = licenses.asl20;
  };
}
