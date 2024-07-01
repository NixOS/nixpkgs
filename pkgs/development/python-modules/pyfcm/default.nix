{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  requests,
}:

buildPythonPackage rec {
  pname = "pyfcm";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "olucurious";
    repo = "pyfcm";
    rev = "refs/tags/${version}";
    sha256 = "sha256-lpSbb0DDXLHne062s7g27zRpvTuOHiqQkqGOtWvuWdI=";
  };

  propagatedBuildInputs = [ requests ];

  # pyfcm's unit testing suite requires network access
  doCheck = false;

  meta = with lib; {
    description = "Python client for FCM - Firebase Cloud Messaging (Android, iOS and Web)";
    homepage = "https://github.com/olucurious/pyfcm";
    license = licenses.mit;
    maintainers = with maintainers; [ ldelelis ];
  };
}
