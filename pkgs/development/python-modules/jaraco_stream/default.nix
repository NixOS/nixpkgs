{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.stream";
  version = "3.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "287e1cba9f278e0146fdded6bc40518930813a5584579769aeaa1d0bfd178a73";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
