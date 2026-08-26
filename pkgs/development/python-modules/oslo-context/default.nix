{
  lib,
  buildPythonPackage,
  fetchPypi,
  oslotest,
  stestr,
  pbr,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "oslo-context";
  version = "6.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "oslo_context";
    hash = "sha256-fh+wPGqXFnlZ832TAwAVTg7oN+zbhXmMK76IeLVsqq8=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
    pbr
    typing-extensions
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
    teams = [ lib.teams.openstack ];
  };
}
