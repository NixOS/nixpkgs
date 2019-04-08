{ lib, buildPythonPackage, fetchPypi, future, networkx, pygments, lxml, colorama, matplotlib,
  asn1crypto, click, pydot, ipython, pyqt5, pyperclip }:

buildPythonPackage rec {
  version = "3.3.5";
  pname = "androguard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0655ca3a5add74c550951e79bd0bebbd1c5b239178393d30d8db0bd3202cda2";
  };

  propagatedBuildInputs = [
    future
    networkx
    pygments
    lxml
    colorama
    matplotlib
    asn1crypto
    click
    pydot
    ipython
    pyqt5
    pyperclip
  ];

  # Tests are not shipped on PyPI.
  doCheck = false;

  meta = {
    description = "Tool and python library to interact with Android Files";
    homepage = https://github.com/androguard/androguard;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.pmiddend ];
  };
}
