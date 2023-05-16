{ lib
, buildPythonPackage
, fetchFromGitHub
, httpsig
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmartapp";
<<<<<<< HEAD
  version = "0.3.5";
=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-RiRGOO5l5hcHllyDDGLtQHr51JOTZhAa/wK8BfMqmAY=";
=======
    hash = "sha256-zYjv7wRxQTS4PnNaY69bw9xE6I4DZMocwUzEICBfwqM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    httpsig
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysmartapp"
  ];

  meta = with lib; {
    description = "Python implementation to work with SmartApp lifecycle events";
    homepage = "https://github.com/andrewsayre/pysmartapp";
    changelog = "https://github.com/andrewsayre/pysmartapp/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
