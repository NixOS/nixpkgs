{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitea,
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
  version = "4.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-watcherclient";
    rev = version;
    hash = "sha256-lDdiZKaeteKZEyfjpBx8KY+0FLFOYAnQXl0pTbqq0Ss=";
  };

  env.PBR_VERSION = version;

  build-system = [
    openstackdocstheme
    pbr
    setuptools
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

  doCheck = true;

  nativeCheckInputs = [ stestr ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "watcherclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-watcherclient";
    description = "Client library for OpenStack Watcher API";
    license = lib.licenses.asl20;
    mainProgram = "watcher";
    maintainers = lib.teams.openstack.members;
  };
}
