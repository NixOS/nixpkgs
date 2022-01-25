{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c685687e3f39e1b9a3ba9c00ed9d8e88603bc8994413e84623e6c5d43214e6f8";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Jalali datetime binding for python";
    homepage = "https://pypi.python.org/pypi/jdatetime";
    license = licenses.psfl;
  };
}
