{ buildPythonPackage
, oslo-config
, oslotest
, stestr
}:

buildPythonPackage rec {
  pname = "oslotest-tests";
  inherit (oslotest) version;

  src = oslotest.src;

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
