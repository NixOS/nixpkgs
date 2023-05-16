{ lib
, aioresponses
, buildPythonPackage
, orjson
, fetchFromGitHub
<<<<<<< HEAD
, pytest-asyncio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "nexia";
<<<<<<< HEAD
  version = "2.0.7";
=======
  version = "2.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-1uCmlFkha5oaNm5N0/8402ulBr7fNRUbDDASECfN9r8=";
=======
    hash = "sha256-VBK+h5K/irI0T0eUaYC1iouzMUo/lJshLTe0h5CtnAQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    orjson
    requests
  ];

  nativeCheckInputs = [
    aioresponses
    requests-mock
<<<<<<< HEAD
    pytest-asyncio
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  pythonImportsCheck = [
    "nexia"
  ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
