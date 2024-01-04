{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, ipykernel
, ipython
, ipywidgets
, nbconvert
, nbformat
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "jupyter-sphinx";
  version = "0.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_sphinx";
    hash = "sha256-LiNpmjoc9dsxsQmB2lqjJgbucw9rc6hE0edtgAdWr1Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    ipykernel
    ipython
    ipywidgets
    nbconvert
    nbformat
    sphinx
  ];

  doCheck = false;

  meta = with lib; {
    description = "Jupyter Sphinx Extensions";
    homepage = "https://github.com/jupyter/jupyter-sphinx/";
    license = licenses.bsd3;
  };

}
