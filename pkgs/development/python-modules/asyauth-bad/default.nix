{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchFromGitHub,
  minikerberos-bad,
  setuptools,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "asyauth-bad";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "asyauth-bAD";
    tag = version;
    hash = "sha256-NX6bvOxA4Y5KRPCIsI+o0cB4dFOXlV89iH7YqNDdaXE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    minikerberos-bad
    unicrypto
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "asyauth" ];

  meta = {
    description = "Unified authentication library";
    homepage = "https://github.com/CravateRouge/asyauth-bAD";
    changelog = "https://github.com/CravateRouge/asyauth-bAD/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
