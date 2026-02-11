{
  lib,
  buildPythonPackage,
  fetchPypi,
  netaddr,
  oslo-i18n,
  pbr,
  pyyaml,
  requests,
  rfc3986,
  setuptools,
  stevedore,
  callPackage,
}:

buildPythonPackage rec {
  pname = "oslo-config";
  version = "10.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "oslo_config";
    inherit version;
    hash = "sha256-bSghE/L7LuTUDIvs20rDmRfD9EfDuzVav0fw1hge3/w=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [ setuptools ];

  dependencies = [
    netaddr
    oslo-i18n
    pbr
    pyyaml
    requests
    rfc3986
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "oslo_config" ];

  meta = {
    description = "Oslo Configuration API";
    homepage = "https://github.com/openstack/oslo.config";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
