{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac5646460defa5bf3d062504d870954c77d6234536365baf52433fb845b620d0";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
