{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fixtures,
  pbr,
  six,
  python-subunit,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "oslotest";
  version = "6.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "oslotest";
    tag = finalAttrs.version;
    hash = "sha256-QberxjPL+bEI0DzOjEmP3bBK4z8ZxtCH8lRtXoqQzyA=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include oslotest *" > MANIFEST.in
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    fixtures
    six
    python-subunit
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [
    "oslotest"
    "oslotest.tools"
  ];

  meta = {
    description = "Oslo test framework";
    homepage = "https://github.com/openstack/oslotest";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
