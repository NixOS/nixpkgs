{
  buildPythonPackage,
  build,
  git,
  gnupg,
  pbr,
  sphinx,
  stestr,
  testresources,
  testscenarios,
  virtualenv,
}:

buildPythonPackage {
  pname = "pbr";
  inherit (pbr) version src;
  format = "other";

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;
  preConfigure = ''
    pythonOutputDistPhase() { touch $dist; }
  '';

  nativeCheckInputs = [
    pbr
    build
    git
    gnupg
    sphinx
    stestr
    testresources
    testscenarios
    virtualenv
  ];

  checkPhase = ''
    stestr run -e <(echo "
    pbr.tests.test_core.TestCore.test_console_script_develop
    pbr.tests.test_core.TestCore.test_console_script_install
    pbr.tests.test_wsgi.TestWsgiScripts.test_with_argument
    pbr.tests.test_wsgi.TestWsgiScripts.test_wsgi_script_run
    ")
  '';
}
