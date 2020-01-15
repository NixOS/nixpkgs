{ stdenv
, buildPythonPackage
, fetchPypi
, pygments
, urwid
, isPy3k
}:

buildPythonPackage rec {
  pname = "pudb";
  version = "2019.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19imrr17jnkd6fd2w1zzh63z0hcipg5b9v2x4svqm5c08p3cyc5c";
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
