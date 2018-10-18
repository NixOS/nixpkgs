{ lib, buildPythonPackage, isPy3k, fetchPypi, ipython_genutils, jupyterlab_launcher, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.34.12";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d8378d19a0ae173e91a493db996c37828b410b7ee556da21a153486168ecf87";
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
