{ buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools_scm, jaraco_collections, importlib-metadata
}:

buildPythonPackage rec {
  pname = "irc";
  version = "18.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qg5996mzvhnkm74ksaa4d47fz5vrpw6hvxyaq9kf6y4cf1l76wq";
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
