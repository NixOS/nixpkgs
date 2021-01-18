{ lib, buildPythonPackage, fetchPypi, ipywidgets, matplotlib }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e2f2e540a2dfea61524b7993fc8552c9236b1aaa3826e1f382c75cb2fa5c382";
  };

  propagatedBuildInputs = [ ipywidgets matplotlib ];

  # There are no unit tests in repository
  doCheck = false;
  pythonImportsCheck = [ "ipympl" "ipympl.backend_nbagg" ];

  meta = with lib; {
    description = "Matplotlib Jupyter Extension";
    homepage = "https://github.com/matplotlib/jupyter-matplotlib";
    maintainers = with maintainers; [ jluttine ];
    license = licenses.bsd3;
  };
}
