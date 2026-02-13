{
  lib,
  buildPythonPackage,
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
  version = "4.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t5zAssGfbG54yCvZI+BnhQNdd8sNKhpIMinwooNvDKc=";
  };

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
