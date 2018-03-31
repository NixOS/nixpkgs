{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Cerberus";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1km7hvns1snrmcwz58bssi4wv3gwd34zm1z1hwjylmpqrfrcf8mi";
  };

  meta = with stdenv.lib; {
    homepage = http://python-cerberus.org/;
    description = "Lightweight, extensible schema and data validation tool for Python dictionaries";
    license = licenses.mit;
  };
}
