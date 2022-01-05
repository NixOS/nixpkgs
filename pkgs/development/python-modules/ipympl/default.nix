{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.5";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "120a084d84e6a6a00fc39c73e10345dcd9855efb3fa6e774f3e72057a866715c";
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
