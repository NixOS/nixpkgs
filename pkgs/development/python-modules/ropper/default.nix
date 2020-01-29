{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonApplication rec {
  pname = "ropper";
  version = "1.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfc87477c0f53d3d2836a384c106373d761cc435eafc477f299523e5404dda43";
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
