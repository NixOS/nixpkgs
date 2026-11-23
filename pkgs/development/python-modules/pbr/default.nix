{
  lib,
  buildPythonPackage,
  callPackage,
  distutils,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pbr";
  version = "7.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "pbr";
    tag = finalAttrs.version;
    hash = "sha256-6u6xxeWFo19lXxO9L1OeBNIR+2qi3OR8+jwluf9pt5Q=";
  };

  env.PBR_VERSION = finalAttrs.version;

  build-system = [ setuptools ];

  dependencies = [
    distutils # for distutils.command in pbr/packaging.py
    setuptools
  ];

  # check in passthru.tests.pytest to escape infinite recursion with fixtures
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "pbr" ];

  meta = {
    description = "Python Build Reasonableness";
    mainProgram = "pbr";
    homepage = "https://github.com/openstack/pbr";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
