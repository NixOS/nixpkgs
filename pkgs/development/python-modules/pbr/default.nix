{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d717573351cfe09f49df61906cd272abaa759b3e91744396b804965ff7bff38b";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
