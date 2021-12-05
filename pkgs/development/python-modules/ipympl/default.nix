{ lib, buildPythonPackage, fetchPypi, ipykernel, ipywidgets }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.2";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "0509gzm5557lyxx8k3qqgp14ifnmfx796cfc8f592mv97pxkyibl";
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
