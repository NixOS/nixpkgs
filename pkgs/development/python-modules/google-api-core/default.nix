{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, googleapis-common-protos
, grpcio
, grpcio-status
, protobuf
, proto-plus
, requests
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8zhjpnCWUXA7ixi2cJNRSDjHnysE0CqlASAwefJLgBg=";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
    google-auth
    grpcio
    grpcio-status
    protobuf
    proto-plus
    requests
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # Those grpc_helpers tests are failing
    "test_wrap_unary_errors"
    "test_wrap_stream_errors_raised"
    "test_wrap_stream_errors_read"
    "test_wrap_stream_errors_aiter"
    "test_wrap_stream_errors_write"
    "test_wrap_unary_errors"
    "test___next___w_rpc_error"
    "test_wrap_stream_errors_invocation"
    "test_wrap_stream_errors_iterator_initialization"
    "test_wrap_stream_errors_during_iteration"
    "test_exception_with_error_code"
  ];

  pythonImportsCheck = [
    "google.api_core"
  ];

  meta = with lib; {
    description = "Core Library for Google Client Libraries";
    longDescription = ''
      This library is not meant to stand-alone. Instead it defines common
      helpers used by all Google API clients.
    '';
    homepage = "https://github.com/googleapis/python-api-core";
    changelog = "https://github.com/googleapis/python-api-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
