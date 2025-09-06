{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  pythonOlder,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-watcherclient";
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-watcherclient";
    tag = version;
    hash = "sha256-ik//J9R9F4SCljexijcfXuSbDgDUNnMTqfpxIPd2Jm8=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxcontrib-apidoc
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
  ];

  nativeCheckInputs = [ stestr ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "watcherclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-watcherclient";
    description = "Client library for OpenStack Watcher API";
    license = lib.licenses.asl20;
    mainProgram = "watcher";
    teams = [ lib.teams.openstack ];
  };
}
