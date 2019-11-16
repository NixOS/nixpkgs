{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03057a3270ddc7d53c31e2915083d01ba8a3169f4032cab3dd9f4ebe44e2564a";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = https://github.com/mozilla-services/vapid;
    license = licenses.mpl20;
  };
}
