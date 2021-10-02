{ lib
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "309ee82b45a0ffca0bc4c7f521fd3e357589c764f339bdf9dcabb7ad40692d6e";
  };

  propagatedBuildInputs = [ pygments urwid ];

  # Tests fail on python 3 due to writes to the read-only home directory
  doCheck = !isPy3k;

  meta = with lib; {
    description = "A full-screen, console-based Python debugger";
    license = licenses.mit;
    platforms = platforms.all;
  };

}
