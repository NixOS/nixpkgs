{ lib, buildPythonPackage, fetchPypi, jupyterlab_server, notebook, pythonOlder
, jupyter-packaging, nbclassic }:

buildPythonPackage rec {
  pname = "jupyterlab";
  version = "3.2.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d74593e52d4dbfacbb98e14cac4bc765ea2cffb1b980675f44930d622871705";
  };

  nativeBuildInputs = [ jupyter-packaging ];

  propagatedBuildInputs = [ jupyterlab_server notebook nbclassic ];

  makeWrapperArgs = [ "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab" ];

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
