{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, ipykernel
, ipython-genutils
, ipywidgets
, matplotlib
, numpy
, pillow
, traitlets
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.3";
  format = "wheel";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-0RPNVYkbr+myfvmbbdERqHvra7KuVQxAQpInIQO+gBM=";
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
  pythonImportsCheck = [ "ipympl" "ipympl.backend_nbagg" ];

  meta = with lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with maintainers; [ jluttine fabiangd ];
    license = licenses.bsd3;
  };
}
