{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "pbr";
  version = "4.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dae4aaa78eafcad10ce2581fc34d694faa616727837fd8e55c1a00951ad6744f";
  };

  # circular dependencies with fixtures
  doCheck = false;

  meta = {
    homepage = http://docs.openstack.org/developer/pbr/;
    license = stdenv.lib.licenses.asl20;
    description = "Python Build Reasonableness";
  };
}
