{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "docker-pycreds";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7ab85de2894baff6ee8f15160cbbfa2fd3a04e56f0372c5793d24060687b299";
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
