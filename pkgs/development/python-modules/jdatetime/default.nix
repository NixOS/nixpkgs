{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21824ab1e29e9ccbca85e77562a090067882976880603c41af8d9c4cffc1d4fc";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Jalali datetime binding for python";
    homepage = https://pypi.python.org/pypi/jdatetime;
    license = licenses.psfl;
  };
}
