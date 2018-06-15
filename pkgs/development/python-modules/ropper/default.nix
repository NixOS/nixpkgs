{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.11.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33777d0c3ddd9ca7bc48f53dbe2c4a222a567f1125c43b1c34fb1b360d0b19dc";
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
