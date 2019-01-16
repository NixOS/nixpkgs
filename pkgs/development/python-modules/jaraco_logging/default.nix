{ buildPythonPackage, fetchPypi, setuptools_scm
, tempora, six }:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1lb846j7qs1hgqwkyifv51nhl3f8jimbc4lk8yn9nkaynw0vyzcg";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ tempora six ];
}
