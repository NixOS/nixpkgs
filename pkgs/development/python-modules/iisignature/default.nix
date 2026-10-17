{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
}:

buildPythonPackage rec {
  pname = "iisignature";
  version = "0.24";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C5MUxui4BIf68yMZH7NZhq1CJuhrDGfPCjspObaVucY=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  # PyPI tarball has no tests
  doCheck = false;

  pythonImportsCheck = [ "iisignature" ];

  meta = {
    description = "Iterated integral signature calculations";
    homepage = "https://pypi.org/project/iisignature";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
