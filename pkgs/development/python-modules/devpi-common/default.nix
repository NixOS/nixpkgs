{ stdenv, pythonPackages }:

with pythonPackages;buildPythonPackage rec {
  pname = "devpi-common";
  version = "3.2.0rc1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ws35g1r0j2xccsna4r6fc9a08przfi28kf9hciq3rmd6ndbr9c9";
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
