{
  lib,
  buildPythonPackage,
  fetchPypi,
  oslotest,
  pbr,
  setuptools,
  testscenarios,
  stestr,
}:

buildPythonPackage rec {
  pname = "oslo-i18n";
  version = "6.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_i18n";
    inherit version;
    hash = "sha256-oLTGTBOWhp1xRNymCtl8frAo949h+RxwB1MSOAUZl98=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    oslotest
    stestr
    testscenarios
  ];

  checkPhase = ''
    runHook preCheck

    stestr run -e <(echo "
    # list is not deduped
    oslo_i18n.tests.test_gettextutils.GettextTest.test_get_available_languages
    ")

    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
