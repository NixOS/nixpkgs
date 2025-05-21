{
  lib,
  buildPythonPackage,
  fetchPypi,
  debtcollector,
  oslotest,
  stestr,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oslo-context";
  version = "5.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "oslo_context";
    hash = "sha256-DFEf4VNzKv8MGztEq9L1EAioPHB7uSm+4B4SVayWSIk=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
    debtcollector
    pbr
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "oslo_context" ];

  meta = with lib; {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
