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
  version = "3.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PHFr9VkssoxcVcYVxuW9PvxxiY9pV9E3GbVkeLu7WHo=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  propagatedBuildInputs = [
    jupyterlab_server
    notebook
    nbclassic
  ];

  makeWrapperArgs = [
    "--set"
    "JUPYTERLAB_DIR"
    "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [
    "jupyterlab"
  ];

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
