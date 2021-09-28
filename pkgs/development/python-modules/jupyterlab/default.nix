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
  version = "3.1.14";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13174cb6076dd5da6f1b85725ccfcc9518d8f98e86b8b644fc89b1dfaeda63a9";
  };

  nativeBuildInputs = [ jupyter-packaging ];

  propagatedBuildInputs = [ jupyterlab_server notebook nbclassic ];

  makeWrapperArgs = [
    "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab" ];

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "https://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
