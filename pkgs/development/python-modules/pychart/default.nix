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
    hash = "sha256-iCZQkod2p8py5nBUqeCsmPeGRfJ5wM+1kQ2yjwPwfC4=";
  };

  meta = with lib; {
    description = "Library for creating high quality encapsulated Postscript, PDF, PNG, or SVG charts";
    homepage = "https://pypi.python.org/pypi/PyChart";
    license = licenses.gpl2;
  };
}
