{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2019.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p2qizb35f9lfhklldzrn8g9mwiar3zmpc44463h5n1ln40ymw78";
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
