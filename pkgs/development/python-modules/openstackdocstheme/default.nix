{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dulwich,
  pbr,
  sphinx,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openstackdocstheme";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "openstackdocstheme";
    tag = finalAttrs.version;
    hash = "sha256-Br8lY9kgWHQIm1Di2W7vVygVk/SRFOXottVHX8kZ9GA=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include openstackdocstheme *" > MANIFEST.in

    patchShebangs bin/
  '';

  build-system = [ setuptools ];

  dependencies = [
    dulwich
    pbr
    sphinx
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "openstackdocstheme" ];

  meta = {
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    homepage = "https://github.com/openstack/openstackdocstheme";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
