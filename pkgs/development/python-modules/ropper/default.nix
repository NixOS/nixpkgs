{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77d9b03083d0a098261a1d2856cd330ea3db520511a78472e421a00526aa220c";
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
