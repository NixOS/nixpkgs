{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, jupyterlab
, pygments
 }:

buildPythonPackage rec {
  pname = "jupyterlab-pygments";
  version = "0.2.2";
  format = "pyproject";

  # requires yarn to build
  src = fetchPypi {
    pname = "jupyterlab_pygments";
    inherit version;
    hash = "sha256-dAXX/eYIGdkFqfqM6J5M2DDjGM2tIqADD3qQHacFWF0=";
  };

  nativeBuildInputs = [
    jupyter-packaging
    pygments
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "jupyterlab_pygments"
  ];

  meta = with lib; {
    description = "Jupyterlab syntax coloring theme for pygments";
    homepage = "https://github.com/jupyterlab/jupyterlab_pygments";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
