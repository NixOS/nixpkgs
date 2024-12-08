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
  version = "6.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    hash = "sha256-ZuBMBB6f8X0H4T7H9IKV+8NhaRQ8csojUqPvzJjntgg=";
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
    maintainers = teams.openstack.members;
  };
}
