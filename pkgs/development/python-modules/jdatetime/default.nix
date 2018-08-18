{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "030a47ad3acbde45cb03872e2c6415c675dbb4a82462302971e93076145b5096";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
