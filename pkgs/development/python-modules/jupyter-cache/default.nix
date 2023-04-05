{ lib
, buildPythonPackage
, fetchPypi
, attrs
, click
, importlib-metadata
, nbclient
, nbformat
, pyyaml
, sqlalchemy
, tabulate
, pythonOlder
, setuptools
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "jupyter-cache";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87408030a4c8c14fe3f8fe62e6ceeb24c84e544c7ced20bfee45968053d07801";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    attrs
    click
    importlib-metadata
    nbclient
    nbformat
    pyyaml
    sqlalchemy
    tabulate
  ];

  pythonRelaxDeps = [
    "nbclient"
    "sqlalchemy" # See https://github.com/executablebooks/jupyter-cache/pull/93
  ];

  pythonImportsCheck = [ "jupyter_cache" ];

  meta = with lib; {
    description = "A defined interface for working with a cache of jupyter notebooks";
    homepage = "https://github.com/executablebooks/jupyter-cache";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
