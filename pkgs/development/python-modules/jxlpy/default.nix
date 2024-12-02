{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cython,
  libjxl,
}:

buildPythonPackage rec {
  pname = "jxlpy";
  version = "0.9.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kqdm8b3hgO0Q3zE68rSIM4Jd7upjG+SQywSseGwCFUI=";
  };

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [ libjxl ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "jxlpy" ];

  meta = {
    description = "Cython bindings and Pillow plugin for JPEG XL";
    homepage = "https://github.com/olokelo/jxlpy";
    changelog = "https://github.com/olokelo/jxlpy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.huantian ];
  };
}
