{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, vobject
, lxml
, requests
, urwid
, pyxdg
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "pycarddav";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0avkrcpisfvhz103v7vmq2jd83hvmpqrb4mlbx6ikkk1wcvclsx8";
  };

  propagatedBuildInputs = [ vobject lxml requests urwid pyxdg ];

  meta = with stdenv.lib; {
    description = "Command-line interface carddav client";
    homepage = http://lostpackets.de/pycarddav;
    license = licenses.mit;
  };

}
