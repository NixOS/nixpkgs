{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07cdb02e8d6610c38e8ae7746b12cbc39068cc5d54fb2baa915579b60d781b5b";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
