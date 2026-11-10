{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  openstackdocstheme,
  pbr,
  setuptools,
  sphinxHook,
  wrapt,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "debtcollector";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "debtcollector";
    tag = finalAttrs.version;
    hash = "sha256-q5A7ZIPMELEIyK7TYL+Eipy1R/h8S6RwIYwgn/Vbzc8=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include debtcollector *" > MANIFEST.in
  '';

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    wrapt
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "debtcollector"
    "debtcollector.fixtures"
  ];

  meta = {
    description = "Collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    homepage = "https://github.com/openstack/debtcollector";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
