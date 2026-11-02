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
  setuptools,
  sphinxHook,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "osc-placement";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-placement";
    tag = finalAttrs.version;
    hash = "sha256-rSabqfpLkNd/h3TepX5W5Sf0+RnVJri1VUiG6HzVkHE=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
    stestrCheckHook
  ];

  pythonImportsCheck = [ "osc_placement" ];

  meta = {
    homepage = "https://github.com/openstack/osc-placement";
    description = "OpenStackClient plugin for the Placement service";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
