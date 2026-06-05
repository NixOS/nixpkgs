{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "bech32";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fW24IUYDvXhx/PpsCCbvaLhbCr2Q+iHChanF4h0r2Jk=";
  };

  build-system = [ setuptools ];

  meta = {
    homepage = "https://pypi.org/project/bech32/";
    license = with lib.licenses; [ mit ];
  };
}
