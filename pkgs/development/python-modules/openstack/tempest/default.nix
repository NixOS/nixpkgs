{ lib, buildPythonApplication, fetchPypi
, pbr, cliff, jsonschema, testtools, paramiko, netaddr, openstack-oslo_concurrency, openstack-oslo_config, openstack-oslo_log, stestr, openstack-oslo_serialization, openstack-oslo_utils, fixtures, pyyaml, subunit, stevedore, prettytable, urllib3, openstack-debtcollector, unittest2
}:

buildPythonApplication rec {
  pname = "openstack-tempest";
  version = "28.0.0";

  src = fetchPypi {
    pname = "tempest";
    inherit version;
    sha256 = "24fcc0baa2044454b17b6b4aa2b1b19682cf95eb92ca38a2f289d3cbc488b170";
  };

  propagatedBuildInputs = [
    pbr
    cliff
    jsonschema
    testtools
    paramiko
    netaddr
    openstack-oslo_concurrency
    openstack-oslo_config
    openstack-oslo_log
    stestr
    openstack-oslo_serialization
    openstack-oslo_utils
    fixtures
    pyyaml
    subunit
    stevedore
    prettytable
    urllib3
    openstack-debtcollector
    unittest2
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/tempest --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "tempest" ];

  meta = with lib; {
    description = "An OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    downloadPage = "https://github.com/openstack/tempest";
    homepage = "https://docs.openstack.org/tempest/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
