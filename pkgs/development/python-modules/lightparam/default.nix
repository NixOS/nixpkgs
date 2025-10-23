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
    sha256 = "13hlkvjcyz2lhvlfqyavja64jccbidshhs39sl4fibrn9iq34s3i";
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
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
