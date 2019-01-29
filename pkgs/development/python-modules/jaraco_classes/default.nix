{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1xfal9085bjh4fv57d6v9ibr5wf4llj73gp1ybdlqd2bralc9hnw";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
