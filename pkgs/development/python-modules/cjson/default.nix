{ stdenv, buildPythonPackage, fetchPypi, isPy3k, isPyPy }:

buildPythonPackage rec {
  pname = "python-cjson";
  version = "1.1.0";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cz87pd411h1fj5am99i19jp53yizcz9mkg1a7cc6a1pb6vsn7x0";
  };

  meta = with stdenv.lib; {
    description = "A very fast JSON encoder/decoder for Python";
    homepage = http://ag-projects.com/;
    license = licenses.lgpl2;
  };
}
