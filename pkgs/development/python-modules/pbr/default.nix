{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fad80b613c402d5b7df7bd84812548b2a61e9977387a80a5fc5c396492b13c9";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = with lib; {
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
