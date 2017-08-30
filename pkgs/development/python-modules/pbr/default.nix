{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "3.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
