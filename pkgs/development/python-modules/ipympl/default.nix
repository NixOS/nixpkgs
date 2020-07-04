{ lib, buildPythonPackage, fetchPypi, ipywidgets, matplotlib }:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sak58wcpikn4ww1k8gr2vf1hmwzfly31hzcnwiizp7l0vk40qh7";
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
