{ stdenv
, buildPythonApplication
, fetchPypi
, capstone
, filebytes
, pytest }:

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "ropper";
  version = "1.10.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1676e07947a19df9d17002307a7555c2647a4224d6f2869949e8fc4bd18f2e87";
  };
  # XXX tests rely on user-writeable /dev/shm to obtain process locks and return PermissionError otherwise
  # workaround: sudo chmod 777 /dev/shm
  checkPhase = ''
    py.test testcases
  '';
  buildInputs = [pytest];
  propagatedBuildInputs = [ capstone filebytes ];
  meta = with stdenv.lib; {
    homepage = "https://scoding.de/ropper/";
    license = licenses.gpl2;
    description = "Show information about files in different file formats";
    maintainers = with maintainers; [ bennofs ];
  };
}
