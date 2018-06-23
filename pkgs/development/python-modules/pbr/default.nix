{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "4.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9c27eb8f0e24e786e544b2dbaedb729c9d8546342b5a6818d8eda098ad4340d";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
