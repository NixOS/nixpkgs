{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "754e766b4f4bad3aa68cfd532456298da1aa39375da8748392dbae90860d5f18";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
