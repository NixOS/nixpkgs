{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, six
, hypothesis
, mock
, levenshtein
, pytestCheckHook
, termcolor
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fire";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "python-fire";
    rev = "refs/tags/v${version}";
    hash = "sha256-cwY1RRNtpAn6LnBASQLTNf4XXSPnfhOa1WgglGEM2/s=";
  };

  patches = [
    # https://github.com/google/python-fire/pull/440
    (fetchpatch {
      name = "remove-asyncio-coroutine.patch";
      url = "https://github.com/google/python-fire/pull/440/commits/30b775a7b36ce7fbc04656c7eec4809f99d3e178.patch";
      hash = "sha256-GDAAlvZKbJl3OhajsEO0SZvWIXcPDi3eNKKVgbwSNKk=";
    })
  ];

  propagatedBuildInputs = [
    six
    termcolor
  ];

  nativeCheckInputs = [
    hypothesis
    mock
    levenshtein
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fire"
  ];

  meta = with lib; {
    description = "A library for automatically generating command line interfaces";
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
    maintainers = with maintainers; [ leenaars ];
  };
}
