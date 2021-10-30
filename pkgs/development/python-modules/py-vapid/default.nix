{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "874f21910f2103c56228cded941d6e733dd8f1eb12876137919533bfacb65a48";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
  };
}
