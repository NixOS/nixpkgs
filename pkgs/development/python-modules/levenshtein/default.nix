{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cmake
<<<<<<< HEAD
, cython_3
=======
, cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, rapidfuzz
, rapidfuzz-cpp
, scikit-build
}:

buildPythonPackage rec {
  pname = "levenshtein";
<<<<<<< HEAD
  version = "0.21.1";
=======
  version = "0.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "Levenshtein";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-I1kVGbZI1hQRNv0e44giWiMqmeqaqFZks20IyFQ9VIU=";
=======
    hash = "sha256-j28OQkJymkh6tIGYLoZLad7OUUImjZqXdqM2zU3haac=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
<<<<<<< HEAD
    cython_3
=======
    cython
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    rapidfuzz-cpp
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.cc.isClang && stdenv.isDarwin) [
    "-fno-lto"  # work around https://github.com/NixOS/nixpkgs/issues/19098
  ]);

  propagatedBuildInputs = [
    rapidfuzz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "Levenshtein"
  ];

  meta = with lib; {
    description = "Functions for fast computation of Levenshtein distance and string similarity";
    homepage = "https://github.com/maxbachmann/Levenshtein";
    changelog = "https://github.com/maxbachmann/Levenshtein/blob/${src.rev}/HISTORY.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
