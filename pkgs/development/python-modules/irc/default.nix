{ lib, buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools-scm, jaraco_collections, importlib-metadata
}:

buildPythonPackage rec {
  pname = "irc";
  version = "20.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "59acb8d69d61a0cbd290e77e6ff10a8c7f2201fb8c7b7d5a195b5883d0c40b0a";
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
