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
  version = "3.1.18";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a43733acc3729557fc4758cff55652e52896e42c64c1f12540656ae7f298b806";
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
