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
  version = "3.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EntKLdFpI0rLFYZkOmzR4+lLkXkh5pv1adeyoqoO9Ak=";
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
