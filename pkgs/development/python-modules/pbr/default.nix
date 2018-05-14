{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "4.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56b7a8ba7d64bf6135a9dfefb85a80d95924b3fde5ed6343a1a1d464a040dae3";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
