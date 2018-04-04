{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b1ksspm86r272ar8v0v4ip1821i4azpix6xhxpb4l133iwsb2y0";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
