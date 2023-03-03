{ lib
, buildPythonPackage
, fetchPypi
, oslotest
, pbr
, testscenarios
, stestr
}:

buildPythonPackage rec {
  pname = "oslo-i18n";
  version = "6.0.0";

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    hash = "sha256-7RBoa3X3xgeCUXemaRVfTiWc459hQ6N19jWbvKpKNc0=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  nativeBuildInputs = [ pbr ];

  nativeCheckInputs = [
    oslotest
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = with lib; {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
