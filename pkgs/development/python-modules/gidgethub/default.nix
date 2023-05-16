{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, uritemplate
, pyjwt
, pytestCheckHook
, aiohttp
, httpx
, importlib-resources
, pytest-asyncio
, pytest-tornasync
}:

buildPythonPackage rec {
  pname = "gidgethub";
<<<<<<< HEAD
  version = "5.3.0";
=======
  version = "5.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "flit";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ns59N/vOuBm4BWDn7Vj5NuSKZdN+xfVtt5FFFWtCaiU=";
=======
    hash = "sha256-pTP4WleVUmFDPCUHAUdjBMw3QDfAq2aw5TcrSEZ0nVw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ]
  ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp
    httpx
    importlib-resources
    pytest-asyncio
    pytest-tornasync
  ];

  disabledTests = [
    # Require internet connection
    "test__request"
    "test_get"
  ];

  meta = with lib; {
    description = "An async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
