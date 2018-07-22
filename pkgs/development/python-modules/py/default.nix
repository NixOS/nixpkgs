{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:
buildPythonPackage rec {
  pname = "py";
  version = "1.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fd59af7435864e1a243790d322d763925431213b6b8529c6ca71081ace3bbf7";
  };

  # Circular dependency on pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = http://pylib.readthedocs.org/;
    license = licenses.mit;
  };
}
