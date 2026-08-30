{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pint,
  psychrolib,
  pytest-asyncio,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyweatherflowudp";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "briis";
    repo = "pyweatherflowudp";
    tag = finalAttrs.version;
    hash = "sha256-4zS6YQmceGfJMGR++VdymIfNq7NAB9jKDT6bVl0wHAc=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    pint
    psychrolib
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyweatherflowudp" ];

  disabledTests = [
    # Tests require network access
    "test_flow_control"
    "test_listen_and_stop"
    "test_repetitive_listen_and_stop"
    "test_process_message"
    "test_listener_connection_errors"
    "test_invalid_messages"
  ];

  meta = {
    description = "Library to receive UDP Packets from Weatherflow Weatherstations";
    homepage = "https://github.com/briis/pyweatherflowudp";
    changelog = "https://github.com/briis/pyweatherflowudp/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
