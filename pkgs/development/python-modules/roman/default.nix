{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "2.0.0";
  format = "setuptools";
  pname = "roman";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "90e83b512b44dd7fc83d67eb45aa5eb707df623e6fc6e66e7f273abd4b2613ae";
  };

  meta = with lib; {
    description = "Integer to Roman numerals converter";
    homepage = "https://pypi.python.org/pypi/roman";
    license = licenses.psfl;
  };
}
