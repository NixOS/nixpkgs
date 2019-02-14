{ lib, buildPythonPackage, fetchPypi, future, networkx, pygments, lxml, colorama, matplotlib,
  asn1crypto, click, pydot, ipython, pyqt5, pyperclip }:

buildPythonPackage rec {
  version = "3.3.4";
  pname = "androguard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hinfbvha7f1py1jnvxih7lx0p4z2nyaiq9bvg8v3bykwrd9jff2";
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
