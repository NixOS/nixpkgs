{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:
buildPythonPackage rec {
  pname = "py";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694";
  };

  # Circular dependency on pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = https://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
