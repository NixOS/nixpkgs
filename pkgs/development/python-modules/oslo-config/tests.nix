{
  buildPythonPackage,
  oslo-config,
  docutils,
  oslo-log,
  oslotest,
  requests-mock,
  sphinx,
  stestr,
  testscenarios,
}:

buildPythonPackage {
  pname = "oslo-config-tests";
  inherit (oslo-config) version src;
  format = "other";

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
