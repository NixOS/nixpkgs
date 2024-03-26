{ lib
, buildPythonPackage
, fetchPypi
, notebook
, qtconsole
, jupyter-console
, nbconvert
, ipykernel
, ipywidgets
}:

buildPythonPackage rec {
  version = "1.0.0";
  format = "setuptools";
  pname = "jupyter";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f";
  };

  propagatedBuildInputs = [ notebook qtconsole jupyter-console nbconvert ipykernel ipywidgets ];

  # Meta-package, no tests
  doCheck = false;

  meta = with lib; {
    description = "Installs all the Jupyter components in one go";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
    priority = 100; # This is a metapackage which is unimportant
  };

}
