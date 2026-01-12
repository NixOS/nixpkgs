{
  lib,
  asn1crypto,
  buildPythonPackage,
  colorama,
  cryptography,
  fetchFromGitHub,
  impacket,
  pyasn1,
}:

buildPythonPackage rec {
  pname = "masky";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Z4kSec";
    repo = "Masky";
    tag = "v${version}";
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

  pythonImportsCheck = [ "masky" ];

  meta = {
    description = "Library to remotely dump domain credentials";
    mainProgram = "masky";
    homepage = "https://github.com/Z4kSec/Masky";
    changelog = "https://github.com/Z4kSec/Masky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ elasticdog ];
  };
}
