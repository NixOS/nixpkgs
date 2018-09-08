{ lib, buildPythonPackage, fetchPypi, setuptools_scm, requests, mock }:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2c5f920d1cabaff8b465447ee152c6985f120b5895f091cf7bf15ff71ade1dc";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock ];

  doCheck = false; # requires network access

  meta = with lib; {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = http://github.com/toastdriven/pysolr/;
    license = licenses.bsd3;
  };
}

