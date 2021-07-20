{ lib
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, urwid-readline
, jedi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJ7oK0Wg/8oLxMf1If0+NXWJx2TzOb353Ku3rUBpLW4=";
  };

  propagatedBuildInputs = [ pygments urwid urwid-readline jedi ];

  # Tests fail on python 3 due to writes to the read-only home directory
  doCheck = !isPy3k;

  pythonImportsCheck = [ "pudb" ];

  meta = with lib; {
    description = "A full-screen, console-based Python debugger";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
