{ lib
, async-timeout
, buildPythonPackage
, cython_3
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "dbus-fast";
  version = "2.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8kK0T5b5hzT8CBYKvYOrc7bKEQxXDsTgjApmrILecek=";
  };

  # The project can build both an optimized cython version and an unoptimized
  # python version. This ensures we fail if we build the wrong one.
  env.REQUIRE_CYTHON = 1;

  nativeBuildInputs = [
    cython_3
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=dbus_fast --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "dbus_fast"
    "dbus_fast.aio"
    "dbus_fast.service"
    "dbus_fast.message"
  ];

  disabledTests = [
    # Test require a running Dbus instance
    "test_aio_big_message"
    "test_aio_properties"
    "test_aio_proxy_object"
    "test_bus_disconnect_before_reply"
    "test_export_alias"
    "test_export_introspection"
    "test_export_unexport"
    "test_fast_disconnect"
    "test_glib_big_message"
    "test_high_level_service_fd_passing"
    "test_interface_add_remove_signal"
    "test_introspectable_interface"
    "test_methods"
    "test_multiple_flags_in_message"
    "test_name_requests"
    "test_object_manager"
    "test_peer_interface"
    "test_property_changed_signal"
    "test_property_changed_signal"
    "test_property_methods"
    "test_sending_file_descriptor_low_level"
    "test_sending_file_descriptor_with_proxy"
    "test_sending_messages_between_buses"
    "test_sending_signals_between_buses"
    "test_signals"
    "test_standard_interface_properties"
    "test_standard_interfaces"
    "test_tcp_connection_with_forwarding"
    "test_unexpected_disconnect"
    # NameError: name '_cast_uint32_native' is not defined
    "test_unmarshall_bluez_interfaces_added_message"
    "test_unmarshall_bluez_interfaces_removed_message"
    "test_unmarshall_bluez_message"
    "test_unmarshall_bluez_properties_changed_with_service_data"
    "test_unmarshall_can_resume"
    "test_unmarshalling_with_table"
    "test_ay_buffer"
  ];

  meta = with lib; {
    description = "Faster version of dbus-next";
    homepage = "https://github.com/bluetooth-devices/dbus-fast";
    changelog = "https://github.com/Bluetooth-Devices/dbus-fast/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
