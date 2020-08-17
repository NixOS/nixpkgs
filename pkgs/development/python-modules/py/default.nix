{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "py";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3b3a4c36512a4c4f024041ab51866f11761cc169670204b235f6b20523d4e6b";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  pythonImportsCheck = [
    "py"
  ];

  meta = with stdenv.lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = "https://pylib.readthedocs.org/";
    license = licenses.mit;
  };
}
