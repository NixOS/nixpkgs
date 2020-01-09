{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Autologging";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "117659584d8aab8cf62046f682f8e57b54d958b8571c737fa8bf15c32937fbb6";
    extension = "zip";
  };

  meta = with stdenv.lib; {
    homepage = http://ninthtest.info/python-autologging/;
    description = "Easier logging and tracing for Python classes";
    license = licenses.mit;
    maintainers = with maintainers; [ twey ];
  };
}
