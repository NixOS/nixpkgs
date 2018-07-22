{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c5983ef1a36b5d98d2b20c16f1d26a52452043d84f3ff1bf8f37e46bc314874";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
