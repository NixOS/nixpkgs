{ stdenv, pythonPackages }:

with pythonPackages;buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d89634a57981ed43cb5dcd25e00c9454ea111189c5ddc08d945b3d5187ada5fd";
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
