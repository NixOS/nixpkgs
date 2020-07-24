{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07f558fece33b05caf857474a366dfcc00562bca13dd8b47b2b3e22d9f9bf55c";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
