{ lib, buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools_scm, jaraco_collections, importlib-metadata, toml
}:

buildPythonPackage rec {
  pname = "irc";
  version = "19.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "29026b1e977dacb621c710ae9531fcab6fa21825b743c616c220da0e58a32233";
  };

  doCheck = false;

  pythonImportsCheck = [ "irc" ];

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    six
    importlib-metadata
    jaraco_logging
    jaraco_text
    jaraco_stream
    pytz
    jaraco_itertools
    jaraco_collections
    toml
  ];

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
    license = licenses.mit;
    maintainers = [];
  };
}
