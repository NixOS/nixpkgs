{
  lib,
  buildPythonPackage,
  debtcollector,
  fetchFromGitea,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  oslotest,
  pbr,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-apidoc,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-designateclient";
  version = "6.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-designateclient";
    rev = version;
    hash = "sha256-vuaouOA69REx+ZrzXjLGVz5Az1/d6x4WRT1h78xeebk=";
  };

  env.PBR_VERSION = version;

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
    sphinxcontrib-apidoc
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    debtcollector
    jsonschema
    keystoneauth1
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  doCheck = true;

  nativeCheckInputs = [
    oslotest
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "designateclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-designateclient";
    description = "Client library for OpenStack Designate API";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members;
  };
}
