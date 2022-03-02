{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.8";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-hkaK6q6MCigAfQx/bbuF8rbLmAUWfojU2qdSlWIAkVk=";
  };


  propagatedBuildInputs = [ ipykernel ipywidgets ];

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
