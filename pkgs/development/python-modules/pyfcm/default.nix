{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  requests,
  urllib3,
  google-auth,
}:

buildPythonPackage rec {
  pname = "pyfcm";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "olucurious";
    repo = "pyfcm";
    rev = "refs/tags/${version}";
    hash = "sha256-lpSbb0DDXLHne062s7g27zRpvTuOHiqQkqGOtWvuWdI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
    google-auth
  ];

  # pyfcm's unit testing suite requires network access
  doCheck = false;

  pythonImportsCheck = [ "pyfcm" ];

  meta = with lib; {
    description = "Python client for FCM - Firebase Cloud Messaging (Android, iOS and Web)";
    homepage = "https://github.com/olucurious/pyfcm";
    license = licenses.mit;
    maintainers = with maintainers; [ ldelelis ];
  };
}
