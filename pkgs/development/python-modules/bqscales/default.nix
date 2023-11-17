{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, hatch-jupyter-builder
, jupyterlab
, jupyter-packaging
, ipywidgets
, numpy
, traitlets
, traittypes
}:

buildPythonPackage rec {
  pname = "bqscales";
  version = "0.3.3";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SlnNw4dWOzRedwIN3kCyl95qVqkY92QGOMS3Eyoqk0I=";
  };

  # We relax dependencies here instead of pulling in a patch because upstream
  # has released a new version using hatch-jupyter-builder, but it is not yet
  # trivial to upgrade to that.
  #
  # Per https://github.com/bqplot/bqscales/issues/76, jupyterlab is not needed
  # as a build dependency right now.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab==3.*",' "" \
      --replace 'jupyter_packaging~=' 'jupyter_packaging>='
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
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
