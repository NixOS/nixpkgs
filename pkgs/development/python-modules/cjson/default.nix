{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isPyPy }:

buildPythonPackage rec {
  pname = "python-cjson";
  version = "1.2.1";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "52db2745264624768bfd9b604acb38f631bde5c2ec9b23861677d747e4558626";
  };

  meta = with stdenv.lib; {
    description = "A very fast JSON encoder/decoder for Python";
    homepage = https://ag-projects.com/;
    license = licenses.lgpl2;
  };
}
