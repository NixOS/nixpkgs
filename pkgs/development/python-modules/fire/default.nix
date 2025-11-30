{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  hypothesis,
  mock,
  levenshtein,
  pytestCheckHook,
  termcolor,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fire";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "python-fire";
    tag = "v${version}";
    hash = "sha256-TZLL7pzX8xPtB/9k3l5395eHrNojmqTH7PfB1kf99Io=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    termcolor
  ];

  nativeCheckInputs = [
    hypothesis
    mock
    levenshtein
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fire" ];

  meta = with lib; {
    description = "Library for automatically generating command line interfaces";
    longDescription = ''
      Python Fire is a library for automatically generating command line
      interfaces (CLIs) from absolutely any Python object.

      * Python Fire is a simple way to create a CLI in Python.

      * Python Fire is a helpful tool for developing and debugging
        Python code.

      * Python Fire helps with exploring existing code or turning other
        people's code into a CLI.

      * Python Fire makes transitioning between Bash and Python easier.

      * Python Fire makes using a Python REPL easier by setting up the
        REPL with the modules and variables you'll need already imported
        and created.
    '';
    homepage = "https://github.com/google/python-fire";
    changelog = "https://github.com/google/python-fire/releases/tag/v${version}";
    license = licenses.asl20;
  };
}
