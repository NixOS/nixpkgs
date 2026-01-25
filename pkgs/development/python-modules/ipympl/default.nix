{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipykernel,
  ipython-genutils,
  ipywidgets,
  matplotlib,
  numpy,
  pillow,
  traitlets,
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.8";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    hash = "sha256-bXIw1Rg4RSEJPzhU99uJ0Gnc2cKKk1s3HpyfEmNU3uE=";
    dist = "py3";
    python = "py3";
  };

  propagatedBuildInputs = [
    ipykernel
    ipython-genutils
    ipywidgets
    matplotlib
    numpy
    pillow
    traitlets
  ];

  # There are no unit tests in repository
  doCheck = false;
  pythonImportsCheck = [
    "ipympl"
    "ipympl.backend_nbagg"
  ];

  meta = {
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with lib.maintainers; [
      jluttine
      fabiangd
    ];
    license = lib.licenses.bsd3;
  };
}
