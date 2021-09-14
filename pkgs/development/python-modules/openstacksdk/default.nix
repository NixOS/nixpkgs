{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, cryptography
, ddt
, dogpile_cache
, hacking
, jmespath
, jsonpatch
, jsonschema
, keystoneauth1
, munch
, netifaces
, os-service-types
, oslo-config
, oslotest
, pbr
, prometheus-client
, requests-mock
, requestsexceptions
, stestr
, testscenarios
}:

buildPythonPackage rec {
  pname = "openstacksdk";
  version = "0.59.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PfdgzScjmKv6yM6+Yu64LLxJe7JdTdcHV290qM6avw0=";
  };

  propagatedBuildInputs = [
    appdirs
    cryptography
    dogpile_cache
    jmespath
    jsonpatch
    keystoneauth1
    munch
    netifaces
    os-service-types
    pbr
    requestsexceptions
  ];

  checkInputs = [
    ddt
    hacking
    jsonschema
    oslo-config
    oslotest
    prometheus-client
    requests-mock
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run -e <(echo "
    openstack.tests.unit.cloud.test_image.TestImage.test_create_image_task
    openstack.tests.unit.image.v2.test_proxy.TestImageProxy.test_wait_for_task_error_396
    openstack.tests.unit.image.v2.test_proxy.TestImageProxy.test_wait_for_task_wait
    openstack.tests.unit.test_resource.TestWaitForStatus.test_status_fails
    openstack.tests.unit.test_resource.TestWaitForStatus.test_status_fails_different_attribute
    openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match
    openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match_with_none
    openstack.tests.unit.test_stats.TestStats.test_list_projects
    openstack.tests.unit.test_stats.TestStats.test_projects
    openstack.tests.unit.test_stats.TestStats.test_servers
    openstack.tests.unit.test_stats.TestStats.test_servers_no_detail
    ")
  '';

  pythonImportsCheck = [ "openstack" ];

  meta = with lib; {
    description = "An SDK for building applications to work with OpenStack";
    homepage = "https://github.com/openstack/openstacksdk";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
