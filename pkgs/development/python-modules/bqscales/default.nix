{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, jupyter-packaging
, ipywidgets
, numpy
, traitlets
, traittypes
}:

buildPythonPackage rec {
  pname = "bqscales";
  version = "0.3.1";

  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C+/GLpqYpePngbn5W0MwvpdmVgFZF7aGHyKMgO5XM90=";
  };

  nativeBuildInputs = [
    hatchling
    jupyter-packaging
  ];

  propagatedBuildInputs = [
    ipywidgets
    numpy
    traitlets
    traittypes
  ];

  # no tests in PyPI dist
  doCheck = false;

  pythonImportsCheck = [ "bqscales" ];

  meta = {
    description = "Grammar of Graphics scales for bqplot and other Jupyter widgets libraries";
    homepage = "https://github.com/bqplot/bqscales";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
