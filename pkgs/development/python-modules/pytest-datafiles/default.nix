{ stdenv, buildPythonPackage, fetchPypi, py, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-datafiles";
  version = "1.0";
  src = fetchPypi {
    inherit version pname;
    sha256 = "1w5435b5pimk6479ml53lmld3qbag7awcg4gl3ljdywc1v096r5v";
  };

  buildInputs = [ py pytest ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    website = https://pypi.python.org/pypi/pytest-catchlog/;
    description = "py.test plugin to create a 'tmpdir' containing predefined files/directories.";
  };
}