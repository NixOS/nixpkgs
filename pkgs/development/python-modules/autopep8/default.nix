{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glibcLocales
, pycodestyle
, pytestCheckHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "autopep8";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-+EZgo7xtYKMgpcntU5FtPrfikDDpnvGHhorhtoqDsvE=";
  };

=======
    hash = "sha256-YEPSsUzJG4MPiiloVAf9m/UiChkhkN0+lK6spycpSvo=";
  };

  patches = [
    # Ignore DeprecationWarnings to fix tests on Python 3.11, https://github.com/hhatto/autopep8/pull/665
    (fetchpatch {
      name = "ignore-deprecation-warnings.patch";
      url = "https://github.com/hhatto/autopep8/commit/75b444d7cf510307ef67dc2b757d384b8a241348.patch";
      hash = "sha256-5hcJ2yAuscvGyI7zyo4Cl3NEFG/fZItQ8URstxhzwzE=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    pycodestyle
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

<<<<<<< HEAD
  env.LC_ALL = "en_US.UTF-8";
=======
  LC_ALL = "en_US.UTF-8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    changelog = "https://github.com/hhatto/autopep8/releases/tag/v${version}";
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://github.com/hhatto/autopep8";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
