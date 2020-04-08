{ lib, buildPythonPackage, fetchPypi, ipywidgets, matplotlib }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m5sh2ha9hlgigc5xxsy7nd0gdadx797h1i66i9z616p0r43gx7d";
  };

  propagatedBuildInputs = [ ipywidgets matplotlib ];

  # There are no unit tests in repository
  doCheck = false;
  pythonImportsCheck = [ "ipympl" "ipympl.backend_nbagg" ];

  meta = with lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = https://github.com/matplotlib/jupyter-matplotlib;
    maintainers = with maintainers; [ jluttine ];
    license = licenses.bsd3;
  };
}
