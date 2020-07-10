{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.stream";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "196synw4g76yagcflmavi7wakf5cdgsflmvbj7zs616gv03xbsf2";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
