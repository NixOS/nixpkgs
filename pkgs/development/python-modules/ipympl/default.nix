{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, matplotlib
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "ipympl";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0f1f356d8cb9d4fb51bb86dbbf837c190145316cb72f66081872ebc4d6db0a1";
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
