{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dotty_dict";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SwFuA7iuJlU5dXpT66JLm/2lBvuU+84L7oQ8bwVUGhU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  doCheck = false;

  meta = with lib; {
    description = "Dictionary wrapper for quick access to deeply nested keys";
    homepage = "https://dotty-dict.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
