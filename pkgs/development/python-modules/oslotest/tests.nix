{ buildPythonPackage
, oslo-config
, oslotest
, stestr
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "oslotest-tests";
  inherit (oslotest) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "oslotest-tests";
  inherit (oslotest) version;

  src = oslotest.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    oslotest
    oslo-config
    stestr
  ];

  checkPhase = ''
    stestr run
  '';
}
