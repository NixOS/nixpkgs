{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.7";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "11c3d01f0555f855c51a960964e3ab4dff38e6ccd1a4695205fe250341a9eb99";
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
