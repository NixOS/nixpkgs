{ buildPythonPackage
, ddt
, hacking
, jsonschema
, lib
, openstacksdk
, oslo-config
, oslotest
, prometheus-client
, requests-mock
, stdenv
, stestr
, testscenarios
}:

buildPythonPackage {
  pname = "openstacksdk-tests";
  inherit (openstacksdk) version;
  format = "other";

  src = openstacksdk.src;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    ddt
    hacking
    jsonschema
    openstacksdk
    oslo-config
    oslotest
    prometheus-client
    requests-mock
    stestr
    testscenarios
  ];

  checkPhase = ''
    stestr run -e <(echo "
  '' + lib.optionalString stdenv.isAarch64 ''
    openstack.tests.unit.cloud.test_baremetal_node.TestBaremetalNode.test_node_set_provision_state_with_retries
    openstack.tests.unit.cloud.test_role_assignment.TestRoleAssignment.test_grant_role_user_domain_exists
    openstack.tests.unit.cloud.test_volume_backups.TestVolumeBackups.test_delete_volume_backup_force
    openstack.tests.unit.object_store.v1.test_proxy.TestTempURLBytesPathAndKey.test_set_account_temp_url_key_second
    openstack.tests.unit.cloud.test_security_groups.TestSecurityGroups.test_delete_security_group_neutron_not_found
  '' + ''
    openstack.tests.unit.cloud.test_baremetal_node.TestBaremetalNode.test_wait_for_baremetal_node_lock_locked
    openstack.tests.unit.cloud.test_baremetal_node.TestBaremetalNode.test_inspect_machine_inspect_failed
    openstack.tests.unit.cloud.test_baremetal_node.TestBaremetalNode.test_inspect_machine_available_wait
    openstack.tests.unit.cloud.test_baremetal_node.TestBaremetalNode.test_inspect_machine_wait
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
    openstack.tests.unit.test_stats.TestStats.test_timeout
    ")
  '';
}
