{ stdenv, pythonPackages }:

with pythonPackages;buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9afa277a9b227d92335c49fab40be2e9bb112c0f4dda84906c14addb1ded2f7";
  };

  propagatedBuildInputs = [ requests py ];
  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/devpi/devpi;
    description = "Utilities jointly used by devpi-server and devpi-client";
    license = licenses.mit;
    maintainers = with maintainers; [ lewo makefu ];
  };
}
