{
  lib,
  buildPythonPackage,
  cliff,
  fetchPypi,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests,
  setuptools,
  sphinx,
  sphinxcontrib-apidoc,
  callPackage,
}:

buildPythonPackage rec {
  pname = "python-octaviaclient";
  version = "3.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_octaviaclient";
    inherit version;
    hash = "sha256-CsZjQ2uSBM3CiNWrldyhh5e1KPVc1Urb28IXNxNnOI8=";
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

  meta = {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://github.com/openstack/python-octaviaclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
