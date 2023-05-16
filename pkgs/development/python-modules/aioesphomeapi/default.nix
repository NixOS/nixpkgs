{ lib
, buildPythonPackage
, fetchFromGitHub
, async-timeout
<<<<<<< HEAD
, chacha20poly1305-reuseable
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, mock
, noiseprotocol
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, zeroconf
}:

buildPythonPackage rec {
  pname = "aioesphomeapi";
<<<<<<< HEAD
  version = "16.0.5";
=======
  version = "13.7.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "esphome";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-SueK59CZTKkQPsHThs7k9eCEmc1GwaRIrw3oSK4E80E=";
=======
    hash = "sha256-licFBWT6CBYHgzVj2dza5gusjapABJWgsfHO/HJafnA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    async-timeout
<<<<<<< HEAD
    chacha20poly1305-reuseable
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    noiseprotocol
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioesphomeapi"
  ];

  meta = with lib; {
    description = "Python Client for ESPHome native API";
    homepage = "https://github.com/esphome/aioesphomeapi";
    changelog = "https://github.com/esphome/aioesphomeapi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab hexa ];
  };
}
