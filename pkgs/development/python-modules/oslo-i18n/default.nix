{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oslotest,
  pbr,
  setuptools,
  stestrCheckHook,
  testscenarios,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-i18n";
  version = "6.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.i18n";
    tag = finalAttrs.version;
    hash = "sha256-FSkz9l0pxJW+qxdzEWcc/G/pLVDsXCpzyPc5MdtTmKE=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_i18n *" > MANIFEST.in

    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    oslotest
    stestrCheckHook
    testscenarios
  ];

  pythonImportsCheck = [ "oslo_i18n" ];

  meta = {
    description = "Oslo i18n library";
    homepage = "https://github.com/openstack/oslo.i18n";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
