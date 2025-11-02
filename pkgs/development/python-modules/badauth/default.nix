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

buildPythonPackage rec {
  pname = "badauth";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "badauth";
    tag = version;
    hash = "sha256-NX6bvOxA4Y5KRPCIsI+o0cB4dFOXlV89iH7YqNDdaXE=";
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
    changelog = "https://github.com/CravateRouge/badauth/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
