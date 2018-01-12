{ stdenv, pythonPackages }:

with pythonPackages;buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rh119iw5hk41gsvbjr0wixvl1i4f0b1vcnw9ym35rmcp517z0wb";
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
