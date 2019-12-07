{ buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools_scm, jaraco_collections, importlib-metadata
}:

buildPythonPackage rec {
  pname = "irc";
  version = "17.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c19aeee800dbad792179d70dff1281c06fec220323f8ec34150cd94357f383b";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    six
    importlib-metadata
    jaraco_logging
    jaraco_text
    jaraco_stream
    pytz
    jaraco_itertools
    jaraco_collections
  ];
}
