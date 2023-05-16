{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "aiotractive";
<<<<<<< HEAD
  version = "0.5.6";
=======
  version = "0.5.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-jJw1L1++Z/r+E12tA6zoyyy4MmTpaaVVzKwfI6xcDBQ=";
=======
    hash = "sha256-VCwIAeSAN4tMwB8TXN/ukrws0qYv/jHHeEu++m56AHA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiotractive" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/zhulik/aiotractive/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Python client for the Tractive REST API";
    homepage = "https://github.com/zhulik/aiotractive";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
