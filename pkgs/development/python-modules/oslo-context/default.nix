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
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "oslo_context";
    hash = "sha256-wajRfHn1DHECTVTMF8wLAeidv/JYMV3BHX4E5rGgLOM=";
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

  meta = with lib; {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
