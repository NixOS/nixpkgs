{ lib
, buildPythonPackage
, fetchPypi
, oslotest
, pbr
, setuptools
, testscenarios
, stestrCheckHook
}:

buildPythonPackage rec {
  pname = "oslo-i18n";
  version = "6.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    hash = "sha256-cPikzphxKRvGCdB+MeblAyZmVWmS/xrlPnjy7SpavoI=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    oslotest
    stestrCheckHook
    testscenarios
  ];

  disabledTests = [
    "oslo_i18n.tests.test_message.MessageTestCase.test_translate_message_bad_translation"
  ];

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = with lib; {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
