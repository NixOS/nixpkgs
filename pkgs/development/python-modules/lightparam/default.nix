{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy3k,
  ipython,
  ipywidgets,
  numpy,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "lightparam";
  version = "0.4.6";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "portugueslab";
    repo = "lightparam";
    rev = "v${version}";
    hash = "sha256-cWgycEw2r+gI1WloCHWLizFJjJJbeezohlR8z+SeFI4=";
  };

  propagatedBuildInputs = [
    ipython
    ipywidgets
    numpy
    pyqt5
  ];

  pythonImportsCheck = [ "lightparam" ];

  meta = {
    homepage = "https://github.com/portugueslab/lightparam";
    description = "Another attempt at parameters in Python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
