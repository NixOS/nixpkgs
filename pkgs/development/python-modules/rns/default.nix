{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, netifaces
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rns";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
    hash = "sha256-wlFDl7yCawLrijQMouFWcRoXmIJRcpHSAKFHyu+sMGk=";
  };

  propagatedBuildInputs = [
    cryptography
    netifaces
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "RNS"
  ];

  meta = with lib; {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://github.com/markqvist/Reticulum";
    changelog = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
