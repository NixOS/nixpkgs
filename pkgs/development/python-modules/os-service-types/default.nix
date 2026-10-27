{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pbr,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "os-service-types";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "os_service_types";
    inherit (finalAttrs) version;
    hash = "sha256-Hy5ftx0fb0/zHYmSZ08jaEZbwvJc2UAYAVw92/xcYX8=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ pbr ];

  dependencies = [ typing-extensions ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "os_service_types" ];

  meta = {
    description = "Python library for consuming OpenStack service-types-authority data";
    homepage = "https://github.com/openstack/os-service-types";
    changelog = "https://github.com/openstack/os-service-types/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
