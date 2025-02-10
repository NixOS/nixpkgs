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
  pythonOlder,
  pyyaml,
  requestsexceptions,
  setuptools,
  sphinxHook,
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  outputs = [
    "out"
    "man"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6NIRsSqBqedjca5O3cqXVh6h/bUEefB3QAz0Ry0q2Jw=";
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

  meta = with lib; {
    description = "SDK for building applications to work with OpenStack";
    mainProgram = "openstack-inventory";
    homepage = "https://github.com/openstack/openstacksdk";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
