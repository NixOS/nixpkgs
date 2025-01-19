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
  version = "5.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OYxGC5z3yzl+3nliIj5LiAePsvvFNmWkejThsoiQ9M4=";
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

  meta = {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members;
  };
}
