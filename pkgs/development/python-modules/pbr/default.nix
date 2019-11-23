{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c8e420cd4ed4cec4e7999ee47409e876af575d4c35a45840d59e8b5f3155ab8";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
