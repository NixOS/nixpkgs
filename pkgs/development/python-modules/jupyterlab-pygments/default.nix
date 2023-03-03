{ lib, buildPythonPackage, fetchPypi, pygments, jupyter-packaging }:

buildPythonPackage rec {
  pname = "jupyterlab_pygments";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dAXX/eYIGdkFqfqM6J5M2DDjGM2tIqADD3qQHacFWF0=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  # no tests exist on upstream repo
  doCheck = false;

  propagatedBuildInputs = [ pygments ];

  pythonImportsCheck = [ "jupyterlab_pygments" ];

  meta = with lib; {
    description = "Jupyterlab syntax coloring theme for pygments";
    homepage = "https://github.com/jupyterlab/jupyterlab_pygments";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
