{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  autopage,
  cmd2,
  openstackdocstheme,
  pbr,
  prettytable,
  pyyaml,
  stevedore,
  sphinxHook,
  callPackage,
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "4.13.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6Um1hbm2RUnehziM79Seh91jCVziufO5j5Ej182Uvho=";
  };

  patches = [
    # Fix compatibility with Python 3.14.3
    (fetchpatch {
      url = "https://github.com/openstack/cliff/commit/391261c849c994ca2d3f42926497e633047ed8c7.patch";
      hash = "sha256-jcjZKJlcJ8C4VKJejb/bjJ6Li4JjeC2xWK/nFWzIL2c=";
    })
  ];

  build-system = [
    openstackdocstheme
    pbr
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    autopage
    cmd2
    prettytable
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [ "cliff" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
