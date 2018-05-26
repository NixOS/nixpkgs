{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "py";
  version = "1.5.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29c9fab495d7528e80ba1e343b958684f4ace687327e6f789a94bf3d1915f881";
  };

  # Circular dependency on pytest
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = http://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
