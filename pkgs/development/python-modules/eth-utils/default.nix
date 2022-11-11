{ lib
, fetchFromGitHub
, buildPythonPackage
, eth-hash
, eth-typing
, cytoolz
, hypothesis
, isPyPy
, pytestCheckHook
, pythonOlder
, toolz
}:

buildPythonPackage rec {
  pname = "eth-utils";
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E2vUROc2FcAv00k50YpdxaaYIRDk1yGSPB8cHHw+7Yw=";
  };

  propagatedBuildInputs = [
    eth-hash
    eth-typing
  ] ++ lib.optional (!isPyPy) cytoolz
  ++ lib.optional isPyPy toolz;


  checkInputs = [
    hypothesis
    pytestCheckHook
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  pythonImportsCheck = [ "eth_utils" ];

  meta = {
    description = "Common utility functions for codebases which interact with ethereum";
    homepage = "https://github.com/ethereum/eth-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
