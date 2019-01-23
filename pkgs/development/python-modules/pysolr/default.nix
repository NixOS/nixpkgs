{ lib, buildPythonPackage, fetchPypi, setuptools_scm, requests, mock }:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88ecb176627db6bcf9aeb94a3570bfa0363cb68be4b2a6d89a957d4a87c0a81b";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock ];

  doCheck = false; # requires network access

  meta = with lib; {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "http://github.com/toastdriven/pysolr/";
    license = licenses.bsd3;
  };
}

