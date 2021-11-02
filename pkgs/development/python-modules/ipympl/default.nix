{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, matplotlib
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef5d21820ed88a8bd6efddb884c333d0eaea7f2f7d4b3054e6d386b07a36dd9d";
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
