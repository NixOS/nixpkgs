{ lib
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2020.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ef23d3371439f13fffbe7f8b9fc180a19d4183dc9cab204d878d7c7766464bf";
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
