{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72f8c72873f9d3f536a696014e4ebffe431a644d7aa95db18c52e086d23b2939";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
