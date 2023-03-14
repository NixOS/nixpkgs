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
  version = "5.1.0";

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    sha256 = "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0";
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
