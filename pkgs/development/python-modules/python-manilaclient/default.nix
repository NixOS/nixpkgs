{
  lib,
  buildPythonPackage,
  callPackage,
  debtcollector,
  fetchPypi,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-config,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  pbr,
  prettytable,
  requests,
  setuptools,
  sphinxHook,
  sphinxcontrib-programoutput,
}:

buildPythonPackage rec {
  pname = "python-manilaclient";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_manilaclient";
    inherit version;
    hash = "sha256-EQwsbwZzFXE+KKDH2SxlC6G8oFvdXo2bK4bJKJZfrVw=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
    sphinxcontrib-programoutput
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    debtcollector
    keystoneauth1
    osc-lib
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    pbr
    prettytable
    requests
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "manilaclient" ];

  meta = {
    description = "Client library for OpenStack Manila API";
    mainProgram = "manila";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
