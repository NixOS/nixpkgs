{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f05cecaa9fc009515086d04b6117324f30eedf1a196f67fb1ec360a9dbdad4ee";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
  };
}
