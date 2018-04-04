{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "docker-pycreds";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j3k5wk3bww5y0f2rvgzsin0q98k0i9j308vpsmxidw0y8n3m0wk";
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
