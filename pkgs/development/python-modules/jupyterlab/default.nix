{ lib, buildPythonPackage, isPy3k, fetchPypi, ipython_genutils, jupyterlab_launcher, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.33.7";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab9f7bcbc3b4e107897f368aa0527cdc1b4ccf0c370e218ae03ac1d75fac261c";
  };

  propagatedBuildInputs = [
    ipython_genutils
    jupyterlab_launcher
    notebook
  ];

  makeWrapperArgs = [
    "--set" "JUPYTERLAB_DIR" "$out/share/jupyter/lab"
  ];

  # Depends on npm
  doCheck = false;

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension.";
    license = with licenses; [ bsd3 ];
    homepage = "http://jupyter.org/";
    maintainers = with maintainers; [ zimbatm costrouc ];
  };
}
