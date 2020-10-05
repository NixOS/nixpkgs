{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14bfd98f51c78a3dd22a1ef45cf194ad79eee4a19e8e1a0d5c7f8e81ffe182ea";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
