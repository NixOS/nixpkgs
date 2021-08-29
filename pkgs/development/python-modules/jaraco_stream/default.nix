{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.stream";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86c57fedffd4d5a4b18817f99ddf62ac8ed0a1bc31a1c41b9a88df9c6bb56e0b";
  };

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
