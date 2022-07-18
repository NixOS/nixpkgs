{ lib
, buildPythonPackage
, fetchFromGitHub
, asn1tools
, coincurve
, eth-hash
, eth-typing
, eth-utils
, factory_boy
, hypothesis
, isPyPy
, pyasn1
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eth-keys";
  version = "0.4.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keys";
    rev = "v${version}";
    sha256 = "sha256-jG/jJPM4t3z6UQIdc8L6y0DxZiGx5pVuGL8XwbIt60o=";
  };

  propagatedBuildInputs = [
    eth-typing
    eth-utils
  ];

  checkInputs = [
    asn1tools
    factory_boy
    hypothesis
    pyasn1
    pytestCheckHook
  ] ++ passthru.optional-dependencies.coincurve
  ++ lib.optional (!isPyPy) eth-hash.optional-dependencies.pysha3
  ++ lib.optional isPyPy eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_keys" ];

  passthru.optional-dependencies = {
    coincurve = [ coincurve ];
  };

  meta = with lib; {
    description = "Common API for Ethereum key operations";
    homepage = "https://github.com/ethereum/eth-keys";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
