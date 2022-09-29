{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodomex
, pythonOlder
}:

buildPythonPackage rec {
  pname = "motionblinds";
  version = "0.6.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "starkillerOG";
    repo = "motion-blinds";
    rev = "refs/tags/${version}";
    sha256 = "sha256-vms9GcB2GQ7fZDk9f9xvFJ5Df7ArEcKn6frIuL1GwPo=";
  };

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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
