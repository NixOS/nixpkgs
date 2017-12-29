{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyserial";
  version="3.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09y68bczw324a4jb9a1cfwrbjhq179vnfkkkrybbksp0vqgl0bbf";
  };

  checkPhase = "python -m unittest discover -s test";

  meta = with lib; {
    homepage = "https://github.com/pyserial/pyserial";
    license = licenses.psfl;
    description = "Python serial port extension";
    maintainers = with maintainers; [ makefu ];
  };
}
