{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.11.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "245c6a1c8b294209bed039cd6a389f1e298d3fe6783d48ad9c6b2df3a41f51ee";
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
