{
  lib,
  buildPythonPackage,
  fetchPypi,
  notebook,
  qtconsole,
  jupyter-console,
  nbconvert,
  ipykernel,
  ipywidgets,
}:

buildPythonPackage rec {
  version = "1.0.0";
  format = "setuptools";
  pname = "jupyter";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2dxLMxjzEONMgpUepdZoP2e+1970sln6+/5PG+sdjl8=";
  };

  propagatedBuildInputs = [
    notebook
    qtconsole
    jupyter-console
    nbconvert
    ipykernel
    ipywidgets
  ];

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
