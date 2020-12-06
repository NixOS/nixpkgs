{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cssselect";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f95f8dedd925fd8f54edb3d2dfb44c190d9d18512377d3c1e2388d16126879bc";
  };

  # AttributeError: 'module' object has no attribute 'tests'
  doCheck = false;

  meta = with stdenv.lib; {
  };
}
