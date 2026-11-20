{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "typing";
  version = "3.10.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b4ad211f54ddbf93e5901a9967b1e07720c1d1b78d596ac6a439641aa1b130";
  };

  doCheck = false;

  meta = {
    description = "Backport of typing module to Python versions older than 3.5";
    homepage = "https://docs.python.org/3/library/typing.html";
    license = lib.licenses.psfl;
  };
}
