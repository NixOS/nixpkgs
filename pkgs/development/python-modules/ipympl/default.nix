{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  version = "0.9.5";
  format = "wheel";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-/xSjV/Q1UuySWC64svdrhEtGmqL6doM/FerX+lhMGfw=";
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

  meta = with lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with maintainers; [
      jluttine
      fabiangd
    ];
    license = licenses.bsd3;
  };
}
