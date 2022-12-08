{ lib, buildPythonPackage, fetchPypi
, flake8, mock, nose, pytest
, cryptography
}:

buildPythonPackage rec {
  pname = "py-vapid";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BmSreJl0LvKyhzl6TUYe9pHtDML1hyBRKNjPYX/9uRk=";
  };

  propagatedBuildInputs = [ cryptography ];

  checkInputs = [ flake8 mock nose pytest ];

  meta = with lib; {
    description = "VAPID is a voluntary standard for WebPush subscription providers";
    homepage = "https://github.com/mozilla-services/vapid";
    license = licenses.mpl20;
  };
}
