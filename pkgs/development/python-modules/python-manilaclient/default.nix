{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  openstackdocstheme,
  oslo-config,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  prettytable,
  requests,
  simplejson,
  setuptools,
  sphinxHook,
  sphinxcontrib-programoutput,
  babel,
  osc-lib,
  python-keystoneclient,
  debtcollector,
  callPackage,
}:

buildPythonPackage rec {
  pname = "python-manilaclient";
  version = "4.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TebykdG0fkeC+5Vs9eiwuJpXam41gg8gR4F2poYKDhI=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
    sphinxcontrib-programoutput
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    pbr
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    prettytable
    requests
    simplejson
    babel
    osc-lib
    python-keystoneclient
    debtcollector
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "manilaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Manila API";
    mainProgram = "manila";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
