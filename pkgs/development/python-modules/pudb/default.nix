{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2018.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vl7rbqyxa2vfa02dg7f5idf1j7awpfcj0dg46ks59xp8539g2wd";
  };

  propagatedBuildInputs = [ pygments urwid ];

  # Tests fail on python 3 due to writes to the read-only home directory
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "A full-screen, console-based Python debugger";
    license = licenses.mit;
    platforms = platforms.all;
  };

}
