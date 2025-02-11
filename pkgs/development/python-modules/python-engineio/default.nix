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
  version = "4.11.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    tag = "v${version}";
    hash = "sha256-3yCT9u3Bz5QPaDtPe1Ezio+O+wWjQ+4pLh55sYAfnNc=";
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
    mock
    tornado
    pytest-asyncio
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
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
    changelog = "https://github.com/miguelgrinberg/python-engineio/blob/v${version}/CHANGES.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
