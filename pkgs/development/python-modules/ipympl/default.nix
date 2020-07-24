{ lib, buildPythonPackage, fetchPypi, ipywidgets, matplotlib }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.5.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cjsabsbn02vpf3yl0x9xdqgf4f707mbnz2hp2bn6zp9qnyyirx5";
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
