{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchFromGitHub,
  kerbad,
  setuptools,
  unicrypto,
}:

buildPythonPackage {
  pname = "badauth";
  version = "0.1.4-unstable-2025-10-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "badauth";
    rev = "86d6091470c98e1a5f6dc4b8749053189372bb53"; # no tag available
    hash = "sha256-p7V5WkQ48b1IqCPwmJfbCiyqekfp9zW41J81JHyZNUQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    kerbad
    unicrypto
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "badauth" ];

  meta = {
    description = "Unified authentication library";
    homepage = "https://github.com/CravateRouge/badauth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
