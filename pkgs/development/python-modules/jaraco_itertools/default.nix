{ buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six }:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "2.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "18cwjbnnnbwld70s3r24sys3blcss84d9ha9hhxsg2d35f9vywd5";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ inflect more-itertools six ];
}
