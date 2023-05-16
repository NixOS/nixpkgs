{ buildPythonPackage
, oslo-config
, docutils
, oslo-log
, oslotest
, requests-mock
, sphinx
, stestr
, testscenarios
}:

<<<<<<< HEAD
buildPythonPackage {
pname = "oslo-config-tests";
  inherit (oslo-config) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "oslo-config-tests";
  inherit (oslo-config) version;

  src = oslo-config.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    oslo-config
    docutils
    oslo-log
    oslotest
    requests-mock
    sphinx
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';
}
