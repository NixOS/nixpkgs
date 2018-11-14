{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b8be50d938c9bb75d0eaf7eda111eec1bf6dc88a62a6412e33bf077457e0f45";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
