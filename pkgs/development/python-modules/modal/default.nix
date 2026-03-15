{
  lib,
  aiohttp,
  buildPythonPackage,
  cbor2,
  certifi,
  click,
  fastapi,
  fetchFromGitHub,
  fetchPypi,
  flaky,
  grpcio-tools,
  grpclib,
  httpx,
  invoke,
  ipython,
  mypy,
  mypy-protobuf,
  protobuf,
  pyjwt,
  pytest-asyncio,
  pytest-env,
  pytest-markdown-docs,
  pytest-timeout,
  pytestCheckHook,
  python-dotenv,
  rich,
  ruff,
  setuptools,
  six,
  synchronicity,
  toml,
  typer,
  types-toml,
  watchfiles,
}:

let
  types-certifi = buildPythonPackage (finalAttrs: {
    pname = "types-certifi";
    version = "2021.10.8.3";
    pyproject = true;

    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-cs93mNFlvAt24cEN0eowl8cGPELCHWZFI7ko6ItVSk8=";
    };

    build-system = [ setuptools ];
  });
in
buildPythonPackage (finalAttrs: {
  pname = "modal";
  version = "1.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-labs";
    repo = "modal-client";
    tag = "py/v${finalAttrs.version}";
    hash = "sha256-DjCEnQ+H03Ga0My2qHGEEF4Ae5HnmlWNvwL+jLdo0pg=";
  };
  sourceRoot = "${finalAttrs.src.name}/py";

  preBuild = ''
    substituteInPlace pyproject.toml --replace-fail 'setuptools~=77.0.3' setuptools
    patchShebangs protoc_plugin/plugin.py
    inv protoc
    inv type-stubs
  '';

  build-system = [
    setuptools
    grpcio-tools
    grpclib
    invoke
    ipython
    mypy-protobuf
    ruff
    synchronicity
  ]
  ++ synchronicity.optional-dependencies.compile;

  dependencies = [
    aiohttp
    cbor2
    certifi
    click
    grpclib
    protobuf
    rich
    synchronicity
    toml
    typer
    types-certifi
    types-toml
    watchfiles
  ];

  nativeCheckInputs = [
    fastapi
    flaky
    httpx
    mypy
    pyjwt
    pytest-asyncio
    pytest-env
    pytest-markdown-docs
    pytest-timeout
    pytestCheckHook
    python-dotenv
    six
  ];

  disabledTestPaths = [
    # Fail due to not finding /bin/bash
    "test/app_composition_test.py"
    "test/cli_shell_test.py"
    "test/cli_test.py"
    "test/container_test.py"
    "test/mounted_files_test.py"

    # Needs unpackaged pythonjsonlogger
    "test/logging_test.py"

    # Matches against error messages of a specific mypy version
    "test/static_types_test.py"

    # Fails due to "Jupyter is migrating its paths to use standard platformdirs"
    "test/notebook_test.py"
  ];
  disabledTests = [
    # Non-deterministic
    "test_queue_blocking_put"
  ];

  pythonImportsCheck = [ "modal" ];

  meta = {
    description = "Python client library for Modal (serverless compute provider)";
    homepage = "https://github.com/modal-labs/modal-client";
    changelog = "https://github.com/modal-labs/modal-client/blob/${finalAttrs.src.tag}/py/CHANGELOG.md";
    mainProgram = "modal";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Kharacternyk ];
  };
})
