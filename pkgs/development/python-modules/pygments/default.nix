{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD

# build-system
, setuptools

# tests
=======
, docutils
, lxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, wcag-contrast-ratio
}:

let pygments = buildPythonPackage
  rec {
    pname = "pygments";
<<<<<<< HEAD
    version = "2.15.1";
    format = "pyproject";
=======
    version = "2.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchPypi {
      pname = "Pygments";
      inherit version;
<<<<<<< HEAD
      hash = "sha256-is5NPB3UgYlLIAX1YOrQ+fGe5k/pgzZr4aIeFx0Sd1w=";
    };

    nativeBuildInputs = [
      setuptools
=======
      hash = "sha256-s+0GqeismpquWm9dvniopYZV0XtDuTwHjwlN3Edq4pc=";
    };

    propagatedBuildInputs = [
      docutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];

    # circular dependencies if enabled by default
    doCheck = false;
<<<<<<< HEAD

    nativeCheckInputs = [
=======
    nativeCheckInputs = [
      lxml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      pytestCheckHook
      wcag-contrast-ratio
    ];

    disabledTestPaths = [
      # 5 lines diff, including one nix store path in 20000+ lines
      "tests/examplefiles/bash/ltmain.sh"
    ];

<<<<<<< HEAD
    pythonImportsCheck = [
      "pygments"
    ];
=======
    pythonImportsCheck = [ "pygments" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    passthru.tests = {
      check = pygments.overridePythonAttrs (_: { doCheck = true; });
    };

    meta = with lib; {
<<<<<<< HEAD
      changelog = "https://github.com/pygments/pygments/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      homepage = "https://pygments.org/";
      description = "A generic syntax highlighter";
      mainProgram = "pygmentize";
      license = licenses.bsd2;
<<<<<<< HEAD
      maintainers = with maintainers; [ ];
=======
      maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
in pygments
