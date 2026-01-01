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
<<<<<<< HEAD
  version = "3.11.0";
=======
  version = "3.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-u9DnRng1MWiA+ZS1U4bJvDwUZzPBfYWj/tMXdVl2xAo=";
=======
    sha256 = "sha256-EntKLdFpI0rLFYZkOmzR4+lLkXkh5pv1adeyoqoO9Ak=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ mock ];

  doCheck = false; # requires network access

<<<<<<< HEAD
  meta = {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "https://github.com/toastdriven/pysolr/";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Lightweight Python wrapper for Apache Solr";
    homepage = "https://github.com/toastdriven/pysolr/";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
