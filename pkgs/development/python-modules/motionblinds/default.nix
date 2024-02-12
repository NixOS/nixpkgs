{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodomex
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "motionblinds";
  version = "0.6.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    rev = "refs/tags/${version}";
    hash = "sha256-Ri14GwRpORk+8RdpPnrOOfDD+sqdQp9ESlYDnaS9ln8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pycryptodomex
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "motionblinds"
  ];

  meta = with lib; {
    description = "Python library for interfacing with Motion Blinds";
    homepage = "https://github.com/starkillerOG/motion-blinds";
    changelog = "https://github.com/starkillerOG/motion-blinds/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
