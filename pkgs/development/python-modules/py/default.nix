{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "py";
  version = "1.5.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca18943e28235417756316bfada6cd96b23ce60dd532642690dcfdaba988a76d";
  };

  # Circular dependency on pytest
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = http://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
