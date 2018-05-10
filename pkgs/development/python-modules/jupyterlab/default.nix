{ lib, buildPythonPackage, isPy3k, fetchPypi, ipython_genutils, jupyterlab_launcher, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab";
  version = "0.31.12";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hp6p9bsr863glildgs2iy1a4l99m7rxj2sy9fmkxp5zhyhqvsrz";
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
