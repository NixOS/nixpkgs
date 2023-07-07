{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, matplotlib
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.3";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-0RPNVYkbr+myfvmbbdERqHvra7KuVQxAQpInIQO+gBM=";
  };


  propagatedBuildInputs = [ ipykernel ipywidgets matplotlib ];

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
