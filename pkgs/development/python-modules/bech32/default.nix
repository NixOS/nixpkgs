{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "bech32";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fW24IUYDvXhx/PpsCCbvaLhbCr2Q+iHChanF4h0r2Jk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "bech32" ];

  meta = {
    homepage = "https://github.com/fiatjaf/bech32";
    license = with lib.licenses; [ mit ];
  };
})
