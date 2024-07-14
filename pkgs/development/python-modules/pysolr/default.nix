{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  requests,
  mock,
}:

buildPythonPackage rec {
  pname = "pysolr";
  version = "3.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bvBf64fGFIlCQ+3cYumwphNKiJwVmuhoZVz2zXSVReY=";
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
