{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
}:

buildPythonPackage rec {
  pname = "pyfcm";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "olucurious";
    repo = "pyfcm";
    rev = "${version}";
    sha256 = "0aj10yvjsc04j15zbn403i83j7ra5yg35pi3ywkyakk8n1s0s3qg";
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
