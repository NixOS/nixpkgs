{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  platformdirs,
  cryptography,
  dogpile-cache,
  jmespath,
  jsonpatch,
  keystoneauth1,
  munch,
  openstackdocstheme,
  os-service-types,
  pbr,
  psutil,
  pyyaml,
  requestsexceptions,
  setuptools,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "4.10.0";
  pyproject = true;

  outputs = [
    "out"
    "man"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xd6a4/HiQRqH/1ey142lP6yOrp5brI5YcJJ8ti3fwDM=";
  };

  postPatch = ''
    # Disable rsvgconverter not needed to build manpage
    substituteInPlace doc/source/conf.py \
      --replace-fail "'sphinxcontrib.rsvgconverter'," "#'sphinxcontrib.rsvgconverter',"
  '';

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  build-system = [ setuptools ];

  dependencies = [
    platformdirs
    cryptography
    dogpile-cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    os-service-types
    pbr
    psutil
    requestsexceptions
    pyyaml
  ];

  # Checks moved to 'passthru.tests' to workaround slowness
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "openstack" ];

  meta = {
    description = "SDK for building applications to work with OpenStack";
    mainProgram = "openstack-inventory";
    homepage = "https://github.com/openstack/openstacksdk";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
