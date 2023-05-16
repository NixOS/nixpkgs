{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytomorrowio";
<<<<<<< HEAD
  version = "0.3.6";
=======
  version = "0.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ZCA+GYuZuRgc4Pi9Bcg4zthOnkmQ+/IddFMkR0WYfKk=";
=======
    hash = "sha256-LFIQJJPqKlqLzEoX9ShfoASigPC5R+OWiW81VmjONe8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytomorrowio"
  ];

  meta = {
    description = "Async Python package to access the Tomorrow.io API";
    homepage = "https://github.com/raman325/pytomorrowio";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
