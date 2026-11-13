{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  msgpack,
  oslo-utils,
  oslotest,
  pbr,
  setuptools,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslo-serialization";
  version = "5.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslo.serialization";
    tag = finalAttrs.version;
    hash = "sha256-hvttFwF+onEa7tWqPKTSh3ua9SRSlW4+JVOuLihFzWc=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslo_serialization *" > MANIFEST.in
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    msgpack
    oslo-utils
  ];

  nativeCheckInputs = [
    oslotest
    stestrCheckHook
  ];

  pythonImportsCheck = [
    "oslo_serialization"
    "oslo_serialization.serializer"
  ];

  meta = {
    description = "Oslo Serialization library";
    homepage = "https://github.com/openstack/oslo.serialization";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
