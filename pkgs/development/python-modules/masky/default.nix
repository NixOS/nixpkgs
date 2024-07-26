{ lib
, asn1crypto
, buildPythonPackage
, colorama
, cryptography
, fetchFromGitHub
, impacket
, pyasn1
, pythonOlder
}:

buildPythonPackage rec {
  pname = "masky";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Z4kSec";
    repo = "Masky";
    rev = "refs/tags/v${version}";
    hash = "sha256-npRuszHkxwjJ+B+q8eQywXPd0OX0zS+AfCro4TM83Uc=";
  };

  propagatedBuildInputs = [
    asn1crypto
    colorama
    cryptography
    impacket
    pyasn1
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "masky"
  ];

  meta = with lib; {
    description = "Library to remotely dump domain credentials";
    homepage = "https://github.com/Z4kSec/Masky";
    changelog = "https://github.com/Z4kSec/Masky/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elasticdog ];
  };
}
