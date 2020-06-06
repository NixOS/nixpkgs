{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isPyPy }:

buildPythonPackage rec {
  pname = "python-cjson";
  version = "1.2.2";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3006c2c218297be3448dc793218e0b15d20fe9839775521bfc294fc6aa24972b";
  };

  meta = with stdenv.lib; {
    description = "A very fast JSON encoder/decoder for Python";
    homepage = "https://ag-projects.com/";
    license = licenses.lgpl2;
  };
}
