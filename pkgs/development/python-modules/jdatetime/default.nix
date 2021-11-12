{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39d0be41076b3a3850c3bfa90817e7ed459edc0e9cadce37dc7229b11f121c7e";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Jalali datetime binding for python";
    homepage = "https://pypi.python.org/pypi/jdatetime";
    license = licenses.psfl;
  };
}
