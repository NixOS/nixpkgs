{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
}:

buildPythonPackage rec {
  pname = "pyfcm";
  version = "1.4.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "olucurious";
    repo = "pyfcm";
    rev = version;
    sha256 = "15q6p21wsjm75ccmzcsgad1w9fgk6189hbrp7pawpxl7l3qxn2p7";
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
