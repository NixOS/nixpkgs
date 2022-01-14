{ lib
, buildPythonPackage
, fetchPypi
, pyqrcode
, requests
, simplejson
}:

buildPythonPackage rec {
  pname = "notify-run";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OjNBb01dzkcOwMC4WNxayyC26nRCmTCnRS+OI+nLc6Q=";
  };

  nativeBuildInputs = [ ];

  checkInputs = [ ];

  propagatedBuildInputs = [ pyqrcode requests simplejson ];

  doCheck = false; # Depends on the entire machine learning world for no good reason

  meta = with lib; {
    description = "notify.run lets you send notifications to your own phone or desktop with minimal fuss";
    homepage = "https://notify.run/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
