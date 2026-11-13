{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  portalocker,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "concurrent-log-handler";
  version = "0.9.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Preston-Landers";
    repo = "concurrent-log-handler";
    tag = finalAttrs.version;
    hash = "sha256-Smka38ihmdaykmHCof1Ts2vgbg4R7kI18a/hpM9PZ4Q=";
  };

  build-system = [ hatchling ];

  dependencies = [ portalocker ];

  pythonImportsCheck = [ "concurrent_log_handler" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/Preston-Landers/concurrent-log-handler/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python logging handler that allows multiple processes to safely write to the same log file concurrently";
    homepage = "https://github.com/Preston-Landers/concurrent-log-handler";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bbjubjub ];
  };
})
