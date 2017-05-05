{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "2.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ccd2db529afd070df815b1521f01401d43de03941170f8a800e7531faba265d";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
