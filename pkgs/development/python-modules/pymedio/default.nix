{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, cryptography
, nibabel
, numpy
, pydicom
, simpleitk
}:

buildPythonPackage rec {
  pname = "pymedio";
<<<<<<< HEAD
  version = "0.2.14";
  format = "setuptools";

=======
  version = "0.2.13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jcreinhold";
    repo = "pymedio";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-x3CHoWASDrUoCXfj73NF+0Y/3Mb31dK2Lh+o4OD9ryk=";
  };

  propagatedBuildInputs = [
    numpy
  ];
=======
    hash = "sha256-iHbClOrtYkHT1Nar+5j/ig4Krya8LdQdFB4Mmm5B9bg=";
  };

  # relax Python dep to work with 3.10.x and 3.11.x
  postPatch = ''
    substituteInPlace setup.cfg --replace "!=3.10.*," "" --replace "!=3.11.*" ""
  '';

  propagatedBuildInputs = [ numpy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
    cryptography
    nibabel
    pydicom
    simpleitk
  ];

  pythonImportsCheck = [
    "pymedio"
  ];

  meta = with lib; {
    description = "Read medical image files into Numpy arrays";
    homepage = "https://github.com/jcreinhold/pymedio";
<<<<<<< HEAD
    changelog = "https://github.com/jcreinhold/pymedio/blob/v${version}/HISTORY.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
