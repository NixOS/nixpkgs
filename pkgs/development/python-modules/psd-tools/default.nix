{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, docopt
, pillow
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, aggdraw
, pytestCheckHook
, ipython
, cython
}:

buildPythonPackage rec {
  pname = "psd-tools";
<<<<<<< HEAD
  version = "1.9.28";
=======
  version = "1.9.24";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-+oxXuZaHkLPuMIsiFOkvW6VLuGxpV7YKs6Gxp/lexVQ=";
=======
    hash = "sha256-RW8v3UeO2tCjKkCqraFw2IfVt2YL3EbixfGsK7pOQYI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    aggdraw
    docopt
    ipython
    pillow
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "psd_tools"
  ];

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = "https://github.com/kmike/psd-tools";
    changelog = "https://github.com/psd-tools/psd-tools/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
