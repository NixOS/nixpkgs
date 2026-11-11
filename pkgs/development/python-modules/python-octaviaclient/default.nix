{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests,
  setuptools,
  sphinx,
  sphinxcontrib-apidoc,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-octaviaclient";
  version = "3.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-octaviaclient";
    tag = finalAttrs.version;
    hash = "sha256-fVDz+fJjacvwY3+BeddQ8DPxtHd72rmTB24UIWhjtaU=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  # NOTE(vinetos): This explicit dependency is removed to avoid infinite recursion
  pythonRemoveDeps = [ "python-openstackclient" ];

  build-system = [
    setuptools
    pbr
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  dependencies = [
    cliff
    keystoneauth1
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "octaviaclient" ];

  meta = {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://github.com/openstack/python-octaviaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
