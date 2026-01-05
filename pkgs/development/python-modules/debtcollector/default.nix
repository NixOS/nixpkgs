{
  lib,
  buildPythonPackage,
  fetchPypi,
  openstackdocstheme,
  pbr,
  six,
  setuptools,
  sphinxHook,
  wrapt,
  callPackage,
}:

buildPythonPackage rec {
  pname = "debtcollector";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KokX0lsOHx0NNl08HG7Px6UiselxbooaSpFRJvfM6m8=";
  };

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    six
    wrapt
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "debtcollector" ];

  meta = with lib; {
    description = "Collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    homepage = "https://github.com/openstack/debtcollector";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
