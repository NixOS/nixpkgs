{ buildPythonPackage
, cliff
, docutils
, stestr
, testscenarios
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "cliff";
  inherit (cliff) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "cliff";
  inherit (cliff) version;

  src = cliff.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    cliff
    docutils
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';
}
