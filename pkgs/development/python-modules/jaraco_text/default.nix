{ buildPythonPackage, fetchPypi, setuptools_scm
, jaraco_functools, jaraco_collections }:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "3660678d395073626e72a455b24bacf07c064138a4cc6c1dae63e616f22478aa";
  };
  doCheck = false;
  buildInputs =[ setuptools_scm ];
  propagatedBuildInputs = [ jaraco_functools jaraco_collections ];
}
