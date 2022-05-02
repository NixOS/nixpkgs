{ lib, buildPythonPackage, fetchPypi, py, pytest }:

buildPythonPackage rec {
  pname = "pytest-datafiles";
  version = "2.0.1";
  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-b2VY0qbny95xT2JBHOhOXALM0ZW9elAmO/3YiL5KFUQ=";
  };

  buildInputs = [ py pytest ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/omarkohl/pytest-datafiles";
    description = "py.test plugin to create a 'tmpdir' containing predefined files/directories.";
  };
}
