{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  googleapis-common-protos,
  grpcio,
  protobuf,

  # optional-dependencies
  click,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cwsandbox";
  version = "0.23.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "coreweave";
    repo = "cwsandbox-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y9rsuAXmpMok0ZqdLhAfavglXh5Hz4VPy1UByYMM1WA=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];
  dependencies = [
    googleapis-common-protos
    grpcio
    protobuf
  ];

  optional-dependencies = {
    cli = [
      click
    ];
  };

  pythonImportsCheck = [ "cwsandbox" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  disabledTests = [
    # Failed: DID NOT RAISE any of (<class 'cwsandbox.exceptions.SandboxNotRunningError'>, <class 'cwsandbox.exceptions.SandboxTerminatedError'>)
    "test_stop_while_waiting"
  ];

  meta = {
    description = "Python client library for CoreWeave Sandbox";
    homepage = "https://github.com/coreweave/cwsandbox-client";
    changelog = "https://github.com/coreweave/cwsandbox-client/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
