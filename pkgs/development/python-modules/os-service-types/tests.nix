{ buildPythonPackage
, keystoneauth1
, os-service-types
, oslotest
, requests-mock
, stestr
, testscenarios
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "os-service-types-tests";
  inherit (os-service-types) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "os-service-types-tests";
  inherit (os-service-types) version;

  src = os-service-types.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    os-service-types
    keystoneauth1
    oslotest
    requests-mock
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';
}
