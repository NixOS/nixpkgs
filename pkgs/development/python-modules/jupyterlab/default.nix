{ lib, buildPythonPackage, isPy3k, fetchPypi, ipython_genutils, jupyterlab_launcher, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.32.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "88290656a2db2e38ef913a257ec283f3b5bd99144ed3d52899c9af7030077554";
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
    maintainers = with maintainers; [ zimbatm ];
  };
}
