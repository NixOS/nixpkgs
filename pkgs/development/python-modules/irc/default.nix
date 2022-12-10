{ lib, buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools-scm, jaraco_collections, importlib-metadata
}:

buildPythonPackage rec {
  pname = "irc";
  version = "20.1.0";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tvc3ky3UeR87GOMZ3nt9rwLSKFpr6iY9EB9NjlU4B+w=";
  };

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

  doCheck = false;

  pythonImportsCheck = [ "irc" ];

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
