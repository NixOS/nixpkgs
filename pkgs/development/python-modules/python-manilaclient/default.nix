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
  version = "5.7.1";
  pyproject = true;

  src = fetchPypi {
    pname = "python_manilaclient";
    inherit version;
    hash = "sha256-BdFUVnvSX7yitHSlP/GzD2jzvF8vh9B4QVVQrqYwW9Q=";
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

  meta = {
    description = "Client library for OpenStack Manila API";
    mainProgram = "manila";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
