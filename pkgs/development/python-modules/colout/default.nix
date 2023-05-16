{ lib
, babel
, buildPythonPackage
, fetchFromGitHub
, pygments
<<<<<<< HEAD
, pythonOlder
=======
, python3Packages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "colout";
<<<<<<< HEAD
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nojhan";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-7Dtf87erBElqVgqRx8BYHYOWv1uI84JJ0LHrcneczCI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

=======
    rev = "v${version}";
    sha256 = "sha256-5ETKNo3KfncnnLTClA6BnQA7SN5KwwsLdQoozI9li7I=";
  };

  nativeBuildInputs = [
    babel
    pygments
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    babel
    pygments
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "colout"
  ];
=======
  pythonImportsCheck = [ "colout" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # This project does not have a unit test
  doCheck = false;

  meta = with lib; {
    description = "Color Up Arbitrary Command Output";
    homepage = "https://github.com/nojhan/colout";
<<<<<<< HEAD
    license = licenses.gpl3Only;
=======
    license = licenses.gpl3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ badele ];
  };
}
