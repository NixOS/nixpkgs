{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f06876c926b8cf88b2f0f68d6cda2b0ff86002385877c9867970e1d017ef82a8";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Jalali datetime binding for python";
    homepage = "https://pypi.python.org/pypi/jdatetime";
    license = licenses.psfl;
  };
}
