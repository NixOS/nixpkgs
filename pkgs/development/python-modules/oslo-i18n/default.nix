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
  version = "6.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_i18n";
    inherit version;
    hash = "sha256-u1477O+i5ASIsln52xLMWtiU3TCbW1rKVjgv8ZDBj14=";
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
    # test counts warnings which no longer matches in python 3.11
    oslo_i18n.tests.test_message.MessageTestCase.test_translate_message_bad_translation
    ")

    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = with lib; {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
