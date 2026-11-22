{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  netaddr,
  oslo-i18n,
  pbr,
  pyyaml,
  requests,
  rfc3986,
  setuptools,
  stevedore,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-config";
  version = "10.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.config";
    tag = finalAttrs.version;
    hash = "sha256-D4QmMDen9RHWUEFMlZ6kZF+DZSslptE0aLRv2A6afkI=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_config *" > MANIFEST.in

    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
    netaddr
    oslo-i18n
    pbr
    pyyaml
    requests
    rfc3986
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "oslo_config"
    "oslo_config.sources"
  ];

  meta = {
    description = "Oslo Configuration API";
    homepage = "https://github.com/openstack/oslo.config";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
