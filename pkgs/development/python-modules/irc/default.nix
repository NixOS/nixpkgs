{ lib, buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools-scm, jaraco_collections, importlib-metadata
}:

buildPythonPackage rec {
  pname = "irc";
  version = "19.0.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99fd5d1fa1d054dee4fbb81e0d5193dc1e8200db751d5da9a97850a62162b9ab";
  };

  doCheck = false;

  pythonImportsCheck = [ "irc" ];

  nativeBuildInputs = [ setuptools-scm ];
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

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
    license = licenses.mit;
    maintainers = [];
  };
}
