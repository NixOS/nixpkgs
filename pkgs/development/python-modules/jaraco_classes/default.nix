{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "3.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "886ad165d495e7d18781142d6dda4f0045053a038f9e63c38ef03e2f7127bafc";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
