{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arpeggio";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    pname = "Arpeggio";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-x5CysG4ibS3UaOT7+1t/UGzsZkFgMf3hRBzx3ioLpwA=";
  };

=======
    hash = "sha256-1rA4OQGbuKaHhfkpLuajaxlU64S5JbhKa4peHibT7T0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arpeggio" ];

  meta = with lib; {
    description = "Recursive descent parser with memoization based on PEG grammars (aka Packrat parser)";
    homepage = "https://github.com/textX/Arpeggio";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ nickcao ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
