{ lib
, anyio
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncio-mqtt";
  version = "0.16.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-f3JqocjOEwNjo6Uv17ij6oEdrjb6Z2wTzdhdVhx46iM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    paho-mqtt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "asyncio_mqtt"
  ];

  disabledTests = [
    # Tests require network access
    "test_client_filtered_messages"
    "test_client_unfiltered_messages"
    "test_client_unsubscribe"
    "test_client_will"
    "test_client_tls_context"
    "test_client_tls_params"
    "test_client_username_password "
    "test_client_logger"
    "test_client_max_concurrent_outgoing_calls"
    "test_client_websockets"
    "test_client_pending_calls_threshold"
    "test_client_no_pending_calls_warnings_with_max_concurrent_outgoing_calls"
    "test_multiple_messages_generators"
  ];

  meta = with lib; {
    description = "Idomatic asyncio wrapper around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/asyncio-mqtt";
    license = licenses.bsd3;
    changelog = "https://github.com/sbtinstruments/asyncio-mqtt/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ hexa ];
  };
}
