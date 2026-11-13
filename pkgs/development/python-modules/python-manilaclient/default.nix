{
  lib,
  buildPythonPackage,
  callPackage,
  debtcollector,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-config,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  pbr,
  prettytable,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-programoutput,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-manilaclient";
  version = "6.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-manilaclient";
    tag = finalAttrs.version;
    hash = "sha256-UmH8nl6wrpQdfZOzef9bwbQ3sxIcvUL7H1juOsy4iQs=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include manilaclient *" > MANIFEST.in
  '';

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
    sphinxcontrib-programoutput
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    debtcollector
    keystoneauth1
    osc-lib
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    pbr
    prettytable
    requests
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "manilaclient"
    "manilaclient.common"
  ];

  meta = {
    description = "Client library for OpenStack Manila API";
    mainProgram = "manila";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
