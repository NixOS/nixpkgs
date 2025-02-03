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
  netifaces,
  openstackdocstheme,
  os-service-types,
  pbr,
  pythonOlder,
  pyyaml,
  requestsexceptions,
  setuptools,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "man"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BghpDKN8pzMnsPo3YdF+ZTlb43/yALhzXY8kJ3tPSYA=";
  };

  postPatch = ''
    # Disable rsvgconverter not needed to build manpage
    substituteInPlace doc/source/conf.py \
      --replace-fail "'sphinxcontrib.rsvgconverter'," "#'sphinxcontrib.rsvgconverter',"
  '';

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    platformdirs
    cryptography
    dogpile-cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    netifaces
    os-service-types
    pbr
    requestsexceptions
    pyyaml
  ];

  # Checks moved to 'passthru.tests' to workaround slowness
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "openstack" ];

  meta = with lib; {
    description = "SDK for building applications to work with OpenStack";
    mainProgram = "openstack-inventory";
    homepage = "https://github.com/openstack/openstacksdk";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
