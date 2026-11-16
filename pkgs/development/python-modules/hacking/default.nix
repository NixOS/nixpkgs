{
  lib,
  buildPythonPackage,
  ddt,
  fetchFromGitHub,
  flake8,
  pbr,
  setuptools,
  stestrCheckHook,
  testscenarios,
}:

buildPythonPackage (finalAttrs: {
  pname = "hacking";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "hacking";
    tag = finalAttrs.version;
    hash = "sha256-C3MEVmGGi0yzsbpai9n8+TQGh3fozF4CfhOhwsTVYt0=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    sed -i 's/flake8.*/flake8/' requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [
    ddt
    stestrCheckHook
    testscenarios
  ];

  pythonImportsCheck = [ "hacking" ];

  meta = {
    description = "OpenStack Hacking Guideline Enforcement";
    homepage = "https://github.com/openstack/hacking";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
