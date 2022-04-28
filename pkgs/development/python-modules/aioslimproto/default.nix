{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    hash = "sha256-kR2PG2eivBfqu67hXr8/RRvo5EzI75e8NmG15NPGo1E=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioslimproto"
  ];

  meta = with lib; {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
