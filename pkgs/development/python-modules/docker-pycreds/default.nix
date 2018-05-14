{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "docker-pycreds";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3732a03610a00461a716997670c7010bf1c214a3edc440f7d6a2a3a830ecd9d";
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
