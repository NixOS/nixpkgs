{ buildPythonPackage, fetchPypi, setuptools_scm
, jaraco_functools, jaraco_collections }:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "1.10.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "07ccc0zc28sb1kyfyviw3n8f581qynrshqvqg1xsp4gkf1m2ibhh";
  };
  doCheck = false;
  buildInputs =[ setuptools_scm ];
  propagatedBuildInputs = [ jaraco_functools jaraco_collections ];
}
