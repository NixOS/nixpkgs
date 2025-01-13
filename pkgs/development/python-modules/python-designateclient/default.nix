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
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-designateclient";
    rev = version;
    hash = "sha256-MwcpRQXH8EjWv41iHxorbFL9EpYu8qOLkDeUx6inEAU=";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
    sphinxcontrib-apidoc
  ];

  sphinxBuilders = [ "man" ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    debtcollector
    jsonschema
    keystoneauth1
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

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
