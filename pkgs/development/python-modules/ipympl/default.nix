{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.4";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "2f955c1c04d8e6df883d57866450657040bfc568edeabcace801cbdbaf4d0295";
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
