{ lib, buildPythonPackage, isPy3k, fetchPypi, ipython_genutils, jupyterlab_launcher, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.33.10";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f9147a2085541118923a71700733ecd1067630b4bc7d8be0ae8d0f9d8131bd9";
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
