{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = with lib; {
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
