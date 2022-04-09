{ lib
, buildPythonPackage
, fetchPypi
, capstone
, filebytes
, pytest
}:

buildPythonPackage rec {
  pname = "ropper";
  version = "1.13.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e4226f5ef01951c7df87029535e051c6deb3f156f7511613fb69e8a7f4801fb";
  };
  # XXX tests rely on user-writeable /dev/shm to obtain process locks and return PermissionError otherwise
  # workaround: sudo chmod 777 /dev/shm
  checkPhase = ''
    py.test testcases
  '';
  doCheck = false; # Tests not included in archive

  checkInputs = [pytest];
  propagatedBuildInputs = [ capstone filebytes ];
  meta = with lib; {
    homepage = "https://scoding.de/ropper/";
    license = licenses.bsd3;
    description = "Show information about files in different file formats";
    maintainers = with maintainers; [ bennofs ];
  };
}
