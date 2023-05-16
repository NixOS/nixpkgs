{ buildPythonPackage
, debtcollector
, stestr
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "debtcollector-tests";
  inherit (debtcollector) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "debtcollector-tests";
  inherit (debtcollector) version;

  src = debtcollector.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    debtcollector
    stestr
  ];

  checkPhase = ''
    stestr run
  '';
}
