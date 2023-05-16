<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, jaraco-collections
, jaraco-itertools
, jaraco-logging
, jaraco-stream
, jaraco-text
, pytestCheckHook
, pythonOlder
, pytz
, setuptools-scm
=======
{ lib, buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools-scm, jaraco_collections, importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "irc";
<<<<<<< HEAD
  version = "20.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JFteqYqwAlZnYx53alXjGRfmDvcIxgEC8hmLyfURMjY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-collections
    jaraco-itertools
    jaraco-logging
    jaraco-stream
    jaraco-text
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "irc"
  ];
=======
  version = "20.1.0";
  format = "pyproject";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tvc3ky3UeR87GOMZ3nt9rwLSKFpr6iY9EB9NjlU4B+w=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
<<<<<<< HEAD
    changelog = "https://github.com/jaraco/irc/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
