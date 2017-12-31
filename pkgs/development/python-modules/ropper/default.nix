{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2183feedfe8b01a27301eee07383b481ece01b2319bdba3afebe33e19ca14aa3";
  };
  # XXX tests rely on user-writeable /dev/shm to obtain process locks and return PermissionError otherwise
  # workaround: sudo chmod 777 /dev/shm
  checkPhase = ''
    py.test testcases
  '';
  doCheck = false; # Tests not included in archive

  checkInputs = [pytest];
  propagatedBuildInputs = [ capstone filebytes ];
  meta = with stdenv.lib; {
    homepage = https://scoding.de/ropper/;
    license = licenses.gpl2;
    description = "Show information about files in different file formats";
    maintainers = with maintainers; [ bennofs ];
  };
}
