{ lib
, stdenv
, backports-cached-property
, blessed
, buildPythonPackage
, cwcwidth
, fetchPypi
, pyte
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "curtsies";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-br4zIVvXyShRpQYEnHIMykz1wZLBZlwdepigTEcCdg4=";
=======
    hash = "sha256-YtEPNJxVOEUwZVan8mY86WsJjYxbvEDa7Hpu7d4WIrA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    blessed
    cwcwidth
  ] ++ lib.optionals (pythonOlder "3.8") [
    backports-cached-property
  ];

  nativeCheckInputs = [
    pyte
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Curses-like terminal wrapper, with colored strings!";
    homepage = "https://github.com/bpython/curtsies";
<<<<<<< HEAD
    changelog = "https://github.com/bpython/curtsies/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
    broken = stdenv.isDarwin;
  };
}
