{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "groestlcoin-hash";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "groestlcoin_hash";
    inherit (finalAttrs) version;
    hash = "sha256-Maj2+kwZ21JYw8c8BxtxcCECyBW6hitgFdnkt17OIx4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "groestlcoin_hash" ];

  meta = {
    description = "Bindings for groestl key derivation function library used in Groestlcoin";
    homepage = "https://github.com/Groestlcoin/groestlcoin-hash-python";
    maintainers = with lib.maintainers; [ gruve-p ];
    license = lib.licenses.mit;
  };
})
