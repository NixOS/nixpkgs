{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e8de790cce397d9bc567a2148c3c5d88740f668342c59aaff9ed004f716a111";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
  };
}
