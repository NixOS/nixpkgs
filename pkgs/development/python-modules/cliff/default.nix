{
  lib,
  buildPythonPackage,
  fetchPypi,
  autopage,
  cmd2,
  importlib-metadata,
  openstackdocstheme,
  pbr,
  prettytable,
  pyparsing,
  pyyaml,
  setuptools,
  stevedore,
  sphinxHook,
  callPackage,
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "4.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WzkhmCk8C5Il1Fm+i6cQz4JI8e4zAGves9kvsAElkrQ=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    autopage
    cmd2
    importlib-metadata
    pbr
    prettytable
    pyparsing
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [ "cliff" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
