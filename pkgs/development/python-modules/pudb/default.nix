{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2016.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0njhi49d9fxbwh5p8yjx8m3jlfyzfm00b5aff6bz473pn7vxfn79";
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
