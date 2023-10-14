{ lib
, buildPythonPackage
, fetchPypi
, attrs
, click
, flit-core
, importlib-metadata
, nbclient
, nbformat
, pyyaml
, sqlalchemy
, tabulate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyter-cache";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Jvg5ARQ+30ry8/9akeLSrSmORuLO4DyAcdN6I6Y8y/w=";
  };

  nativeBuildInputs = [
    flit-core
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

  pythonImportsCheck = [ "jupyter_cache" ];

  meta = with lib; {
    description = "A defined interface for working with a cache of jupyter notebooks";
    homepage = "https://github.com/executablebooks/jupyter-cache";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
