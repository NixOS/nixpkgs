{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, espeak-ng
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "espeak-phonemizer";
<<<<<<< HEAD
  version = "1.3.1";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "espeak-phonemizer";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-K0s24mzXUqG0Au40jjGbpKNAznBkMHQzfh2/CDBN0F8=";
=======
    hash = "sha256-F+A2ge9YAib6IjDW3RNi7QqKnh1RGy2mlPFEB+OLCJU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    (substituteAll {
      src = ./cdll.patch;
      libespeak_ng = "${lib.getLib espeak-ng}/lib/libespeak-ng.so";
    })
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/espeak-phonemizer/releases/tag/v${version}";
    description = "Uses ctypes and libespeak-ng to transform test into IPA phonemes";
    homepage = "https://github.com/rhasspy/espeak-phonemizer";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
