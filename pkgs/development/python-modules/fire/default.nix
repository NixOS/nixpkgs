{ stdenv, buildPythonPackage, fetchFromGitHub, six, hypothesis, mock
, python-Levenshtein, pytest }:

buildPythonPackage rec {
  pname = "fire";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "python-fire";
    rev = "v${version}";
    sha256 = "0kdcmzr3sgzjsw5fmvdylgrn8akqjbs433jbgqzp498njl9cc6qx";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ hypothesis mock python-Levenshtein pytest ];

  checkPhase = ''
    py.test
  '';


  meta = with stdenv.lib; {
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
    license = licenses.asl20;
    maintainers = with maintainers; [ leenaars ];
  };
}
