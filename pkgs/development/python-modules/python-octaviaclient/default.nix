{
  lib,
  buildPythonPackage,
  cliff,
  fetchPypi,
  keystoneauth1,
  makePythonPath,
  openstackdocstheme,
  installer,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  pbr,
  python-neutronclient,
  requests,
  setuptools,
  sphinx,
  sphinxcontrib-apidoc,
  callPackage,
}:

buildPythonPackage rec {
  pname = "python-octaviaclient";
  version = "3.12.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_octaviaclient";
    inherit version;
    hash = "sha256-5brfxkpJQousEcXl0YerzYDjrfl0XyWV0RXPTz146Y4=";
  };

  # NOTE(vinetos): This explicit dependency is removed to avoid infinite recursion
  pythonRemoveDeps = [ "python-openstackclient" ];

  build-system = [
    setuptools
    pbr
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  dependencies = [
    cliff
    keystoneauth1
    python-neutronclient
    osc-lib
    oslo-serialization
    oslo-utils
    requests
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "octaviaclient" ];

  meta = with lib; {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://github.com/openstack/python-octaviaclient";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
