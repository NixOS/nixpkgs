{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, matplotlib
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.1";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-NQW0ctQSF4/RFeJVdk0efnYy1sgunebWKyVDijU3RoA=";
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
