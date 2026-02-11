{
  lib,
  buildPythonPackage,
  fetchPypi,
  oauthlib,
  aiohttp,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aiohttp-oauthlib";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iTzRpZ3dDC5OmA46VE+XELfE/7nie0zQOLUf4dcDk7c=";
  };

  propagatedBuildInputs = [
    oauthlib
    aiohttp
  ];

  nativeBuildInputs = [ setuptools-scm ];

  # Package has no tests.
  doCheck = false;

  meta = {
    homepage = "https://git.sr.ht/~whynothugo/aiohttp-oauthlib";
    description = "oauthlib integration for aiohttp clients";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sumnerevans ];
  };
}
