{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "139d2625547dbfa5fb0b81daebb39601c478c21956dc57e2e07b74450a8c506b";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
