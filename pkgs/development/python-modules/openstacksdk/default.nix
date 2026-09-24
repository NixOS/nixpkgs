{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  callPackage,
  pbr,
  setuptools,

  # direct
  cryptography,
  dogpile-cache,
  jmespath,
  jsonpatch,
  keystoneauth1,
  munch,
  os-service-types,
  platformdirs,
  psutil,
  pyyaml,

  # docs
  sphinxHook,
  openstackdocstheme,
}:

buildPythonPackage (finalAttrs: {
  pname = "openstacksdk";
  version = "4.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "openstacksdk";
    tag = finalAttrs.version;
    hash = "sha256-nMpUNLz7OosoGd5rozWcOcOEf3jdEHo5dhxmOv0xONw=";
  };

  patches = [
    ./fix-pyproject.patch
  ];

  postPatch = ''
    # Disable rsvgconverter not needed to build manpage
    substituteInPlace doc/source/conf.py \
      --replace-fail "'sphinxcontrib.rsvgconverter'," "#'sphinxcontrib.rsvgconverter',"
  '';

  env.PBR_VERSION = finalAttrs.version;

  build-system = [
    pbr
    setuptools
  ];

  outputs = [
    "out"
    "man"
  ];

  sphinxBuilders = [ "man" ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  dependencies = [
    platformdirs
    cryptography
    dogpile-cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    os-service-types
    psutil
    pyyaml
  ];

  # Checks moved to 'passthru.tests' to workaround slowness
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  # Non-exhaustive imports
  pythonImportsCheck = [
    "openstack"
    "openstack.config.loader"
    "openstack.compute.v2.server"
    "openstack.test"
  ];

  meta = {
    description = "SDK for building applications to work with OpenStack clouds.";
    mainProgram = "openstack";
    homepage = "https://docs.openstack.org/openstacksdk/latest/";
    downloadPage = "https://github.com/openstack/openstacksdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
