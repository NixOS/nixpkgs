{
  buildPythonPackage,
  ddt,
  hacking,
  jsonschema,
  keyring,
  openstacksdk,
  oslo-config,
  oslotest,
  prometheus-client,
  requests-mock,
  statsd,
  stestrCheckHook,
  testscenarios,
}:

buildPythonPackage {
  pname = "openstacksdk-tests";
  inherit (openstacksdk) version src;
  pyproject = false;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    ddt
    hacking
    jsonschema
    keyring
    openstacksdk
    oslo-config
    oslotest
    prometheus-client
    requests-mock
    statsd
    stestrCheckHook
    testscenarios
  ];

  disabledTests = [
    "openstack.tests.unit.cloud.test_volume_backups.TestVolumeBackups.test_delete_volume_backup_force"
    "openstack.tests.unit.image.v2.test_proxy.TestTask.test_wait_for_task_error_396"
    "openstack.tests.unit.image.v2.test_proxy.TestTask.test_wait_for_task_wait"
    "openstack.tests.unit.test_resource.TestWaitForDelete.test_callback"
    "openstack.tests.unit.test_resource.TestWaitForDelete.test_callback_without_progress"
    "openstack.tests.unit.test_resource.TestWaitForDelete.test_status"
    "openstack.tests.unit.test_resource.TestWaitForDelete.test_success_not_found"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_callback"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_callback_without_progress"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_fails"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_fails_different_attribute"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match_different_attribute"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match_none"
    "openstack.tests.unit.test_resource.TestWaitForStatus.test_status_match_with_none"
  ];
}
