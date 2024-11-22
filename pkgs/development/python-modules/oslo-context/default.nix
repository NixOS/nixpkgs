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
  pname = "oslo.context";
  version = "5.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UiLDJja+BwojDfnTFBoLJ6lfCjtpePTBSFvK2kekw8s=";
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
    maintainers = teams.openstack.members;
  };
}
