{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pymailgunner";
  version = "1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "pymailgunner";
    rev = version;
    hash = "sha256-QKwpW1aeN6OI76Kocow1Zhghq4/fl/cMPexny0MTwQs=";
  };

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymailgunner" ];

  meta = with lib; {
    description = "Library for interacting with Mailgun e-mail service";
    homepage = "https://github.com/pschmitt/pymailgunner";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
