{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db57ee517356b1bfc1603ef412f5da61eae92241ba0bcaf0851028cae424780c";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Jalali datetime binding for python";
    homepage = "https://pypi.python.org/pypi/jdatetime";
    license = licenses.psfl;
  };
}
