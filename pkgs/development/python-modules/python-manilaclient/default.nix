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
  version = "5.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_manilaclient";
    inherit version;
    hash = "sha256-wPYVZ0+a9g+IP3l3eH9gMWXfe5VGUzem7qWEOWZ+vlo=";
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
    teams = [ teams.openstack ];
  };
}
