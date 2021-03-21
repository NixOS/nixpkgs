{ lib
, buildPythonPackage
, fetchPypi
, jupyterlab_server
, notebook
, pythonOlder
, jupyter-packaging
, nbclassic
}:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "3.0.11";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zkz08xFjzlGu0BPAGoV8BdQ6k8Ru1pAWbkhkT255R94=";
  };

  propagatedBuildInputs = [ jupyterlab_server notebook jupyter-packaging nbclassic ];

  makeWrapperArgs = [
    "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
