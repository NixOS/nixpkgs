{ lib, buildPythonPackage, fetchPypi, setuptools-scm, requests, mock }:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rj5jmscvxjwcmlfi6hmkj44l4x6n3ln5p7d8d18j566hzmmzw3f";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ mock ];

  doCheck = false; # requires network access

  meta = with lib; {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "https://github.com/toastdriven/pysolr/";
    license = licenses.bsd3;
  };
}

