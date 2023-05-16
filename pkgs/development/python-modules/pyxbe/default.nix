{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyxbe";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mborgerson";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-iLzGGgizUbaEG1xrNq4WDaWrGtcaLwAYgn4NGYiSDBo=";
=======
    hash = "sha256-oOY0g1F5sxGUxXAT19Ygq5q7pnxEhIAKmyYELR1PHEA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Update location for run with pytest
  preCheck = ''
    substituteInPlace tests/test_load.py \
<<<<<<< HEAD
      --replace '"xbefiles"' '"tests/xbefiles"'
=======
      --replace "'xbefiles'" "'tests/xbefiles'"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  pythonImportsCheck = [
    "xbe"
  ];

  meta = with lib; {
    description = "Library to work with XBE files";
    homepage = "https://github.com/mborgerson/pyxbe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
