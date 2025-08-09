{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  setuptools,
  eventlet,
  fetchFromGitHub,
  iana-etc,
  libredirect,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  simple-websocket,
  tornado,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "python-engineio";
  version = "4.12.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    tag = "v${version}";
    hash = "sha256-VgdqVzO3UToXpD9pMEDqAH2DfdBwaWUfulALAEG2DNs=";
  };

  build-system = [ setuptools ];

  dependencies = [ simple-websocket ];

  optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [ aiohttp ];
  };

  nativeCheckInputs = [
    eventlet
    libredirect.hook
    mock
    tornado
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf)
  '';

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  disabledTests = [
    # Assertion issue
    "test_async_mode_eventlet"
    # Somehow effective log level does not change?
    "test_logger"
  ];

  pythonImportsCheck = [ "engineio" ];

  meta = with lib; {
    description = "Python based Engine.IO client and server";
    longDescription = ''
      Engine.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    changelog = "https://github.com/miguelgrinberg/python-engineio/blob/${src.tag}/CHANGES.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
