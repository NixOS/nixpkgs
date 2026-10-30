{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  autopage,
  cmd2_4,
  openstackdocstheme,
  pbr,
  prettytable,
  pyyaml,
  stevedore,
  sphinxHook,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "cliff";
  version = "4.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "cliff";
    tag = finalAttrs.version;
    hash = "sha256-YADr4oT2u/CavqD0Se7IvdHwPlbiGFNbhlnph/Vy5uQ=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include cliff *" > MANIFEST.in
  '';

  build-system = [
    openstackdocstheme
    pbr
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    autopage
    cmd2_4
    prettytable
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [
    "cliff"
    "cliff.formatters"
  ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
