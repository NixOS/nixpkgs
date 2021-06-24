{ lib, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "py";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ca6883ce56b4e8da7e79ac18787889fa5206c79dcc67fb065376cd2fe03f342";
  };

  # Circular dependency on pytest
  doCheck = false;

  nativeBuildInputs = [ setuptools_scm ];

  pythonImportsCheck = [
    "py"
  ];

  meta = with lib; {
    description = "Library with cross-python path, ini-parsing, io, code, log facilities";
    homepage = "https://py.readthedocs.io/";
    license = licenses.mit;
  };
}
