{ lib
, buildPythonPackage
, fetchFromGitHub
, cached-property
, eth-typing
, eth-utils
, mypy-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-ecc";
  version = "6.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "py_ecc";
    rev = "v${version}";
    sha256 = "sha256-638otYA3e/Ld4mcM69yrqHQnGoK/Sfl/UA9FWnjgO/U=";
  };

  propagatedBuildInputs = [
    cached-property
    eth-typing
    eth-utils
    mypy-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "py_ecc" ];

  meta = with lib; {
    description = "ECC pairing and bn_128 and bls12_381 curve operations";
    homepage = "https://github.com/ethereum/py_ecc";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
