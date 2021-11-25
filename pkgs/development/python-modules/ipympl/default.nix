{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, matplotlib
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b84adbad8c1a6993bfbac4f08396eb851dd4171eb0b632f2840a838dd104810";
  };

  propagatedBuildInputs = [ ipywidgets matplotlib jupyter-packaging ];

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
