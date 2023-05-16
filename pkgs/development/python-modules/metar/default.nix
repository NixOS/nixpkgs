{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
=======
, fetchpatch
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "metar";
<<<<<<< HEAD
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-ZDjlXcSTUcSP7oRdhzLpXf/fLUA7Nkc6nj2I6vovbHg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "metar"
  ];
=======
    rev = "v${version}";
    hash = "sha256-pl2NWRfFCYyM2qvBt4Ic3wgbGkYZvAO6pX2Set8zYW8=";
  };

  patches = [
    # Fix flapping test; https://github.com/python-metar/python-metar/issues/161
    (fetchpatch {
      url = "https://github.com/python-metar/python-metar/commit/716fa76682e6c2936643d1cf62e3d302ef29aedd.patch";
      hash = "sha256-y82NN+KDryOiH+eG+2ycXCO9lqQLsah4+YpGn6lM2As=";
      name = "fix_flapping_test.patch";
    })

    # Fix circumvent a sometimes impossible test
    # https://github.com/python-metar/python-metar/issues/165
    (fetchpatch {
      url = "https://github.com/python-metar/python-metar/commit/b675f4816d15fbfc27e23ba9a40cdde8bb06a552.patch";
      hash = "sha256-v+E3Ckwxb42mpGzi2C3ka96wHvurRNODMU3xLxDoVZI=";
      name = "fix_impossible_test.patch";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "metar" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
<<<<<<< HEAD
    changelog = "https://github.com/python-metar/python-metar/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
