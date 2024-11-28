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
  version = "4.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-placement";
    rev = "refs/tags/${version}";
    hash = "sha256-PUwyYOg1dymlnnTr6TnxS42ISmbS00YfOdkL+5MbYFI=";
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
    maintainers = lib.teams.openstack.members;
  };
}
