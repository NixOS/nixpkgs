{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "pymailgunner";
  version = "1.5";
  format = "setuptools";

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

  meta = {
    description = "Library for interacting with Mailgun e-mail service";
    homepage = "https://github.com/pschmitt/pymailgunner";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
