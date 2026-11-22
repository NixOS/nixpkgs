{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchPypi,
  kerbad,
  setuptools,
  unicrypto,
}:

buildPythonPackage (finalAttrs: {
  pname = "badauth";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kv+U0sUveJsSrLondCpVy/G+EAVnTEl/rGC7Z27qCKc=";
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
})
