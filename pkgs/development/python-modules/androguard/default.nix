{ lib, buildPythonPackage, fetchPypi, future, networkx, pygments, lxml, colorama, matplotlib,
  asn1crypto, click, pydot, ipython, pyqt5, pyperclip }:

buildPythonPackage rec {
  version = "3.3.3";
  pname = "androguard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zlmn3byh2whg7k2xmcd7yy43lcawhryjnzcxr9bhn54709b6iyd";
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
