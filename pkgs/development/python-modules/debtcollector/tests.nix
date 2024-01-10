{ buildPythonPackage
, debtcollector
, stestr
}:

buildPythonPackage {
  pname = "debtcollector-tests";
  inherit (debtcollector) version src;
  format = "other";

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
