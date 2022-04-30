{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "python-vagrant";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qP6TzPL/N+zJXsL0nqdKkabOc6TbShapjdJtOXz9CeU=";
  };

  # The tests try to connect to qemu
  doCheck = false;

  pythonImportsCheck = [
    "vagrant"
  ];

  meta = {
    description = "Python module that provides a thin wrapper around the vagrant command line executable";
    homepage = "https://github.com/todddeluca/python-vagrant";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
