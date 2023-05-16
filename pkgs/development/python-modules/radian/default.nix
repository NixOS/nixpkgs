{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pyte
, pexpect
, ptyprocess
, jedi
, git
, lineedit
, prompt-toolkit
, pygments
, rchitect
<<<<<<< HEAD
, R
, rPackages
, pythonOlder
=======
, six
, R
, rPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "radian";
<<<<<<< HEAD
  version = "0.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";
=======
  version = "0.6.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "randy3k";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-MEstbQj1dOcrukgDvMwL330L9INEZcIupebrSYMOrZk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
=======
    rev = "v${version}";
    sha256 = "iuD4EkGZ1GwNxR8Gpg9ANe3lMHJYZ/Q/RyuN6vZZWME=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace '"pytest-runner"' ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    R # needed at setup time to detect R_HOME
  ];

  propagatedBuildInputs = [
    lineedit
    prompt-toolkit
    pygments
    rchitect
<<<<<<< HEAD
=======
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ (with rPackages; [
    reticulate
    askpass
  ]);

  nativeCheckInputs = [
    pytestCheckHook
    pyte
    pexpect
    ptyprocess
    jedi
    git
  ];

<<<<<<< HEAD
  makeWrapperArgs = [ "--set R_HOME ${R}/lib/R" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export HOME=$TMPDIR
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${R}/lib/R/lib
  '';

  pythonImportsCheck = [ "radian" ];

  meta = with lib; {
    description = "A 21 century R console";
    homepage = "https://github.com/randy3k/radian";
<<<<<<< HEAD
    changelog = "https://github.com/randy3k/radian/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
