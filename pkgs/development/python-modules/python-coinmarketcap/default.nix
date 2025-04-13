{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "python-coinmarketcap";
  version = "0.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rsz44";
    repo = "python-coinmarketcap";
    rev = "de069d55d7cc5eea9cd194b47d4609c4846d59d1";
    hash = "sha256-FQIfDV7O3z5S2HGKi2k8NPsvkAS66rsueggoSAGvbVU=";
  };

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "coinmarketcapapi"
  ];

  meta = with lib; {
    description = "Python package to wrap the CoinMarketCap API";
    homepage = "https://github.com/rsz44/python-coinmarketcap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ dolphindalt ];
  };
}
