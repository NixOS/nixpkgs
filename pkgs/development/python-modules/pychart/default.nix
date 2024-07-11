{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
}:

buildPythonPackage rec {
  pname = "pychart";
  version = "1.39";
  format = "setuptools";

  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "882650928776a7ca72e67054a9e0ac98f78645f279c0cfb5910db28f03f07c2e";
  };

  meta = with lib; {
    description = "Library for creating high quality encapsulated Postscript, PDF, PNG, or SVG charts";
    homepage = "https://pypi.python.org/pypi/PyChart";
    license = licenses.gpl2;
  };
}
