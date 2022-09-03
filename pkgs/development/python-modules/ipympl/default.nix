{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, matplotlib
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.9.2";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-ZVYE8L9tJkz1mXZpUKWybiktEHzCPhl1A2R+dUF5gcw=";
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
