{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyopenssl,

  # test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioopenssl";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "horazont";
    repo = "aioopenssl";
    tag = "v${version}";
    hash = "sha256-7Q+4/DlP+kUnC3YNk7woJaxLEEiuVmolUOajepM003Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyopenssl ];

  pythonImportsCheck = [ "aioopenssl" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests that fail in when built in the Darwin sandbox.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # address already in use
    "test_renegotiate"
    # permission error (tries to bind to port not allowed by sandbox)
    "test_abort"
    "test_close_during_handshake"
    "test_connect_send_recv_close"
    "test_data_is_sent_after_handshake"
    "test_local_addr"
    "test_no_data_is_received_after_handshake"
    "test_no_data_is_received_if_handshake_crashes"
    "test_no_data_is_sent_if_handshake_crashes"
    "test_post_handshake_exception_is_propagated"
    "test_recv_large_data"
    "test_renegotiation"
    "test_send_and_receive_data"
    "test_send_large_data"
    "test_send_recv_large_data"
    "test_starttls"
  ];

  __darwinAlowLocalNetworking = true;

  meta = {
    description = "TLS-capable transport using OpenSSL for asyncio";
    homepage = "https://github.com/horazont/aioopenssl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
