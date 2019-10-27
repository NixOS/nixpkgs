{ buildPythonPackage, fetchPypi, setuptools_scm
, jaraco_functools
}:

buildPythonPackage rec {
  pname = "jaraco.text";
  version = "3.0.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "08n14knfarc3v9jibkl1pbcq2fd95cmz61wc6n4y922ccnrqn9gc";
  };
  doCheck = false;
  buildInputs =[ setuptools_scm ];
  propagatedBuildInputs = [ jaraco_functools ];
}
