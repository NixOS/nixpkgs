{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f20ec0abbf132471b68963bb34d9c78e603a5cf9e24473f14358e66551d47475";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
