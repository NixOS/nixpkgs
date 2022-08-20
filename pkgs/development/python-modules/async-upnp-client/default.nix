{ lib
, stdenv
, aiohttp
, async-timeout
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, python-didl-lite
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "async-upnp-client";
  version = "0.31.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = "async_upnp_client";
    rev = version;
    sha256 = "sha256-/8gSx1oe2ljBGIPddzBLXuH3LiuHpUXi4/vO7stm5FY=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    defusedxml
    python-didl-lite
    voluptuous
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # socket.gaierror: [Errno -2] Name or service not known
    "test_async_get_local_ip"
    "test_get_local_ip"
    # OSError: [Errno 101] Network is unreachable
    "test_auto_resubscribe_fail"
    "test_init"
    "test_on_notify_dlna_event"
    "test_on_notify_upnp_event"
    "test_server_init"
    "test_server_start"
    "test_start_server"
    "test_subscribe"
    "test_subscribe_auto_resubscribe"
    "test_subscribe_fail"
    "test_subscribe_manual_resubscribe"
    "test_subscribe_renew"
    "test_unsubscribe"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_deferred_callback_url"
  ];

  disabledTestPaths = [
    # Tries to bind to multicast socket and fails to find proper interface
    "tests/test_ssdp_listener.py"
  ];

  pythonImportsCheck = [
    "async_upnp_client"
  ];

  meta = with lib; {
    description = "Asyncio UPnP Client library for Python";
    homepage = "https://github.com/StevenLooman/async_upnp_client";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
