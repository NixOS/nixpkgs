{ buildPythonPackage
, keystoneauth1
, os-service-types
, oslotest
, requests-mock
, stestrCheckHook
, testscenarios
}:

buildPythonPackage {
  pname = "os-service-types-tests";
  inherit (os-service-types) version src;
  format = "other";

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
    stestrCheckHook
    testscenarios
  ];
}
