{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7facd437d27365e217787e1013ecdc402aa77af7248e16128f6a753920000905";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
