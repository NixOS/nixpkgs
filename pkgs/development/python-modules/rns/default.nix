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
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
    hash = "sha256-awVUE5sViaGBne82oAxGeabZSnLn/dzBQTwP7xRdYKE=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
