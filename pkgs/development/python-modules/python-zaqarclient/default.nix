{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitea,
  jsonschema,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-utils,
  pbr,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-zaqarclient";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-zaqarclient";
    rev = version;
    hash = "sha256-WphTlqhrwxg5g88NH1W4b3uLAxLImnS34hDrlJjWeEU=";
  };

  env.PBR_VERSION = version;

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    jsonschema
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-log
    oslo-utils
    requests
    stevedore
  ];

  doCheck = true;

  nativeCheckInputs = [
    ddt
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "zaqarclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-zaqarclient";
    description = "Client library for OpenStack Zaqar API";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members;
  };
}
