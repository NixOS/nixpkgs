{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.stream";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "c2e9d507d8cf04a3ff916b57eaf46bacb8a9f8895b55ead853de9c47b8f5daa4";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
