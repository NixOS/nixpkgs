{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95eb8364a4708392bae89035f45341871286a333f749c3141c20573d2b3876e1";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jgeerds ];
  };
}