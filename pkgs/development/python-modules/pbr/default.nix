{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c361cc353d988e4f5b998555c88098b9d5964c2e11acf7b0d21925a66bb5824";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
