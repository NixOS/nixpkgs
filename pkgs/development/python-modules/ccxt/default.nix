{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  requests,
  certifi,
  aiohttp,
  cryptography,
  aiodns,
  yarl,
  typing-extensions,
  coincurve,
}:

buildPythonPackage rec {
  pname = "ccxt";
  version = "4.5.20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IjE+SAv81t9RlsDt9HxuWTeTwzk/DgAsywb110pWzdE=";
  };

  postPatch = ''
    sed -i '/with open(readme/,/long_description = f.read()/d' setup.py
    sed -i 's/long_description=long_description,/long_description="CCXT - Cryptocurrency Trading Library",/' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    certifi
    aiohttp
    cryptography
    aiodns
    yarl
    typing-extensions
    coincurve
  ];

  doCheck = false;

  pythonImportsCheck = [ "ccxt" ];

  meta = {
    description = "Cryptocurrency trading library";
    homepage = "https://github.com/ccxt/ccxt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cybermanu84 ];
  };
}
