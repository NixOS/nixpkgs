{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wapg9n7myn7c82r3nzs2gisfzx52nip8w2mrfy0yih1zn02mnd6";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false; # no tests in PyPI tarball

  meta = with lib; {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "http://github.com/toastdriven/pysolr/";
    license = licenses.bsd3;
  };
}

