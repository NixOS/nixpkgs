{
  lib,
  buildPythonPackage,

  # build-system
  setuptools,

  # nativeBuildInputs
  grpcio-tools,
  grpclib,
  installAgentSkills,
  invoke,
  ipython,
  mypy-protobuf,
  ruff,

  # dependencies
  aiohttp,
  cbor2,
  certifi,
  click,
  protobuf,
  rich,
  synchronicity,
  toml,
  typer,
  types-certifi,
  types-toml,
  typing-extensions,
  watchfiles,

  # tests
  fastapi,
  fetchFromGitHub,
  flaky,
  httpx,
  mypy,
  pyjwt,
  pytest-asyncio,
  pytest-env,
  pytest-markdown-docs,
  pytest-timeout,
  pytestCheckHook,
  python-dotenv,
  six,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "modal";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-labs";
    repo = "modal-client";
    tag = "py/v${finalAttrs.version}";
    hash = "sha256-Tg1VvCKuDWuF67bfUtKadat2eVZAXru5g17aXLnwR8U=";
  };
  sourceRoot = "${finalAttrs.src.name}/py";

  postPatch =
    # On Python 3.14 (deferred annotations), `list` resolves to the classes' own `list` methods,
    # which breaks `inv type-stubs`
    ''
      substituteInPlace modal/sandbox/_sandbox.py \
        --replace-fail \
          "import asyncio" \
          "import asyncio, builtins" \
        --replace-fail \
          "-> list[tuple[str, str]]:" \
          "-> builtins.list[tuple[str, str]]:"
      substituteInPlace modal/_workspace.py \
        --replace-fail \
          "-> list[ServiceUserInfo]:" \
          "-> builtins.list[ServiceUserInfo]:"
    ''
    + ''
      patchShebangs protoc_plugin/plugin.py
      inv protoc
      inv type-stubs
    '';

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    grpcio-tools
    grpclib
    installAgentSkills
    invoke
    ipython
    mypy-protobuf
    ruff
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
    typing-extensions
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
    versionCheckHook
  ];

  preInstall = ''
    rm -rf build/lib/modal/skills
  '';

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

    # try to hit modal servers
    "test_blob_upload_uses_proxy"
    "test_grpc_control_plane_uses_prox"
    "test_grpc_task_command_router_uses_proxy"
    "test_socks5_proxy_via_all_proxy"

    # flaky
    "test_process_fork"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "modal" ];

  meta = {
    description = "Python client library for Modal (serverless compute provider)";
    homepage = "https://github.com/modal-labs/modal-client";
    changelog = "https://github.com/modal-labs/modal-client/blob/${finalAttrs.src.rev}/py/CHANGELOG.md";
    mainProgram = "modal";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Kharacternyk ];
  };
})
