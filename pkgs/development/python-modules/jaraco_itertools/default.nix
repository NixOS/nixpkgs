{ buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six }:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "3.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "19d8557a25c08f7a7b8f1cfa456ebfd615bafa0f045f89bbda55f99661b0626d";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ inflect more-itertools six ];
}
