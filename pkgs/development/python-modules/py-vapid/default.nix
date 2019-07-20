{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3g4ljkpi6ka5n63bl5y47r3qhxjmr6qfamqwxnmna2567b5las";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = https://github.com/mozilla-services/vapid;
    license = licenses.mpl20;
  };
}
