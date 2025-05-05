{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  oslotest,
  pbr,
  pythonOlder,
  setuptools,
  sphinxHook,
  stestr,
}:

buildPythonPackage rec {
  pname = "osc-placement";
  version = "4.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-placement";
    tag = version;
    hash = "sha256-8D/8WRUZnVTCXL/I+KmIGKtnfyjM7evux808+XY3ciw=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    keystoneauth1
    osc-lib
    oslo-utils
    pbr
  ];

  nativeCheckInputs = [
    oslo-serialization
    oslotest
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "osc_placement" ];

  meta = {
    homepage = "https://opendev.org/openstack/osc-placement";
    description = "OpenStackClient plugin for the Placement service";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
