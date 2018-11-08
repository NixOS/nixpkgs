{ buildPythonPackage, fetchPypi, setuptools_scm, six }:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "1.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "002zsifikv6qwigkjlij7jhyvbwv6793m8h9ckbkx2jizmgc80fi";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];
}
