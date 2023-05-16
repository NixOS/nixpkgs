{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, gcc
, click
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "primer3";
<<<<<<< HEAD
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libnano";
    repo = "primer3-py";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Ku2PVrWYWPKnNXeUQmstQedJg1O0hsQl4/iEnAMMEaY=";
  };

  nativeBuildInputs = [
    cython
  ] ++ lib.optionals stdenv.isDarwin [
    gcc
  ];

  # pytestCheckHook leads to a circular import issue
  nativeCheckInputs = [
    click
  ];

  pythonImportsCheck = [
    "primer3"
  ];
=======
    hash = "sha256-o9B8TN3mOchOO7dz34mI3NDtIhHSlA9+lMNsYcxhTE0=";
  };

  nativeBuildInputs = [ cython ]
    ++ lib.optionals stdenv.isDarwin [ gcc ];

  # pytestCheckHook leads to a circular import issue
  nativeCheckInputs = [ click ];

  pythonImportsCheck = [ "primer3" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Oligo analysis and primer design";
    homepage = "https://github.com/libnano/primer3-py";
<<<<<<< HEAD
    changelog = "https://github.com/libnano/primer3-py/blob/v${version}/CHANGES";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
