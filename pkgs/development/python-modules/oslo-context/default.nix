{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oslotest,
  pbr,
  setuptools,
  stestrCheckHook,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-context";
  version = "6.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.context";
    tag = finalAttrs.version;
    hash = "sha256-T5mDtkDLVZORNQZA84StgqEQAKIF0aK1R0zIObIeWf4=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_context *" > MANIFEST.in

    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
    pbr
    typing-extensions
  ];

  nativeCheckInputs = [
    oslotest
    stestrCheckHook
  ];

  pythonImportsCheck = [ "oslo_context" ];

  meta = {
    description = "Oslo Context library";
    homepage = "https://github.com/openstack/oslo.context";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
