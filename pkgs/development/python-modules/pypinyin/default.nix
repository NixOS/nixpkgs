{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pypinyin";
<<<<<<< HEAD
  version = "0.49.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.48.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mozillazg";
    repo = "python-pinyin";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-4XiPkx7tYD5PQVyeJ/nvxrRzWmeLp9JfY1B853IEE7U=";
=======
    hash = "sha256-gt0jrDPr6FeLB5P9HCSosCHb/W1sAKSusTrCpkqO26E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pytest.ini --replace \
      "--cov-report term-missing" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  meta = with lib; {
    description = "Chinese Characters to Pinyin - 汉字转拼音";
    homepage = "https://github.com/mozillazg/python-pinyin";
<<<<<<< HEAD
    changelog = "https://github.com/mozillazg/python-pinyin/blob/v${version}/CHANGELOG.rst";
=======
    changelog = "https://github.com/mozillazg/python-pinyin/blob/master/CHANGELOG.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
