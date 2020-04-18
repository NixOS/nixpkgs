{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, six, hypothesis, mock
, python-Levenshtein, pytest, termcolor, isPy27, enum34 }:

buildPythonPackage rec {
  pname = "fire";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "python-fire";
    rev = "v${version}";
    sha256 = "0s5r6l39ck2scks54hmwwdf4lcihqqnqzjfx9lz2b67vxkajpwmc";
  };

  propagatedBuildInputs = [ six termcolor ] ++ stdenv.lib.optional isPy27 enum34;

  checkInputs = [ hypothesis mock python-Levenshtein pytest ];

  # ignore test which asserts exact usage statement, default behavior
  # changed in python3.8. This can likely be remove >=0.3.1
  checkPhase = ''
    py.test -k 'not testInitRequiresFlag'
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
