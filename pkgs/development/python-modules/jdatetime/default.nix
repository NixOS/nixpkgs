{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42d0d08c0d36dcf1c4e1ddb1d10338d0dffb94105a02d74b6ea655ee8dd93cc2";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
