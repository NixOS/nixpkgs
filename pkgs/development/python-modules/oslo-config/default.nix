{ lib
, buildPythonPackage
, fetchPypi
, debtcollector
, netaddr
, oslo-i18n
, pbr
, pyyaml
, requests
, rfc3986
, stevedore
, callPackage
}:

buildPythonPackage rec {
  pname = "oslo-config";
  version = "9.1.1";

  src = fetchPypi {
    pname = "oslo.config";
    inherit version;
    hash = "sha256-sHZUtT2HeSro5zmWKtcpxSnJk4oRjYkezp7jHVlxa8k=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  propagatedBuildInputs = [
    debtcollector
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
    tests = callPackage ./tests.nix {};
  };

  pythonImportsCheck = [ "oslo_config" ];

  meta = with lib; {
    description = "Oslo Configuration API";
    homepage = "https://github.com/openstack/oslo.config";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
