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
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-watcherclient";
  version = "4.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-watcherclient";
    tag = finalAttrs.version;
    hash = "sha256-TYMV55uvTCvHKj5w5QA2zRqVr6pXCXh2Oc07Yo7epjs=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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

  nativeCheckInputs = [ stestrCheckHook ];

  pythonImportsCheck = [ "watcherclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-watcherclient";
    description = "Client library for OpenStack Watcher API";
    license = lib.licenses.asl20;
    mainProgram = "watcher";
    teams = [ lib.teams.openstack ];
  };
})
