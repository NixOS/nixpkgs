{ buildPythonPackage
, cliff
, docutils
, stestr
, testscenarios
}:

buildPythonPackage rec {
  pname = "cliff";
  inherit (cliff) version;

  src = cliff.src;

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
