{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aignpxz6rcbf6yxy1gjr708p56i6nqrbgblq24nanssz9rhkyzg";
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
    license = licenses.bsd3;
    description = "Show information about files in different file formats";
    maintainers = with maintainers; [ bennofs ];
  };
}
