{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,

  # build-system
  bun,
  nodejs,
  stdenvNoCC,
  uv-build,

  # dependencies
  dirhash,
  fastapi,
  filelock,
  httpx,
  jinja2,
  litellm,
  packaging,
  pathspec,
  platformdirs,
  pydantic,
  pyjwt,
  python-dotenv,
  pyyaml,
  requests,
  rich,
  shortuuid,
  supabase,
  tenacity,
  toml,
  typer,
  uvicorn,

  # tests
  cwsandbox,
  dockerfile-parse,
  hypothesis,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,

  # runtime tools
  docker-client,
  git,
  uv,

  # passthru
  nix-update-script,

  runCommand,

  # features
  computer1Support ? false,
  anthropic,
  google-genai,
  openai,

  ec2Support ? false,
  boto3,

  gkeSupport ? false,
  kubernetes,

  wandbSupport ? false,
  wandb,

  langsmithSupport ? false,
  langsmith,
  harbor-langsmith,

  atif2otelSupport ? false,
  harbor-atif2otel,
}:

buildPythonPackage (finalAttrs: {
  pname = "harbor";
  version = "0.20.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "harbor-framework";
    repo = "harbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uV7aWuRw+KuyGkA9srhEioZ8YWH8PzwYx5SQ7BUdV6E=";
  };

  viewerNodeModules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-viewer-node_modules";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/apps/viewer";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --backend=copyfile \
        --cpu="*" \
        --os="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/node_modules

      runHook postInstall
    '';

    outputHash = "sha256-vYzs0TNeXeNSCgk4ggTk72rZ7rpAEUWebYyYsiJhLbg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  # Nixpkgs has a newer uv-build than upstream allows.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.4,<0.9.0' 'uv_build>=0.8.4'

    cp -R ${finalAttrs.viewerNodeModules}/node_modules apps/viewer/
    chmod -R u+w apps/viewer/node_modules
    patchShebangs apps/viewer/node_modules
  '';

  build-system = [ uv-build ];

  nativeBuildInputs = [
    bun
    nodejs
  ];

  preBuild = ''
    pushd apps/viewer
    bun run build
    popd

    rm -rf src/harbor/viewer/static
    mkdir -p src/harbor/viewer/static
    cp -R apps/viewer/build/client/* src/harbor/viewer/static/
  '';

  dependencies = [
    dirhash
    fastapi
    filelock
    httpx
    jinja2
    litellm
    packaging
    pathspec
    platformdirs
    pydantic
    pyjwt
    python-dotenv
    pyyaml
    requests
    rich
    shortuuid
    supabase
    tenacity
    toml
    typer
    uvicorn
  ]
  ++ lib.optionals computer1Support [
    anthropic
    google-genai
    openai
  ]
  ++ lib.optionals computer1Support anthropic.optional-dependencies.bedrock
  ++ lib.optionals ec2Support [ boto3 ]
  ++ lib.optionals gkeSupport [ kubernetes ]
  ++ lib.optionals wandbSupport [
    cwsandbox
    wandb
  ]
  ++ lib.optionals langsmithSupport [
    (harbor-langsmith.override { propagateHarbor = false; })
    langsmith
  ]
  ++ lib.optionals atif2otelSupport [ harbor-atif2otel ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      docker-client
      git
      uv
    ])
  ];

  nativeCheckInputs = [
    cwsandbox
    dockerfile-parse
    git
    hypothesis
    pandas
    pytest-asyncio
    pytestCheckHook
    uv
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export UV_NO_MANAGED_PYTHON=1
    export UV_PYTHON=${python.interpreter}
    export UV_PYTHON_DOWNLOADS=never
  '';

  # Docker tests require a daemon unavailable in the sandbox.
  enabledTestPaths = [
    "tests/unit"
    "tests/runtime/test_installed_agent.py"
  ];

  disabledTestPaths = [
    # Optional SDKs unavailable in nixpkgs.
    "tests/unit/environments/test_blaxel.py"

    "tests/unit/environments/test_daytona.py"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_daytona_accepts_docker_image_without_dockerfile"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_missing_definition_raises[DaytonaEnvironment]"

    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_e2b_accepts_docker_image_without_dockerfile"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_missing_definition_raises[E2BEnvironment]"

    "tests/unit/environments/test_islo.py"

    "tests/unit/environments/test_novita.py"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_novita_accepts_docker_image_without_dockerfile"

    "tests/unit/environments/test_runloop.py"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_runloop_accepts_docker_image_without_dockerfile"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_runloop_defaults_workdir_when_dockerfile_has_no_workdir"
    "tests/unit/environments/test_environment_definition.py::TestProviderValidation::test_missing_definition_raises[RunloopEnvironment]"

    "tests/unit/environments/test_tensorlake.py"
  ]
  ++ lib.optionals (!computer1Support) [
    "tests/unit/agents/computer_1"
    "tests/unit/agents/test_factory_computer_1.py"
  ]
  ++ lib.optionals (!gkeSupport) [
    "tests/unit/environments/test_gke.py"
  ]
  ++ lib.optionals (!langsmithSupport) [
    "tests/unit/test_langsmith_environment.py"
  ]
  ++ lib.optionals (!wandbSupport) [
    "tests/unit/environments/cwsandbox/test_wandb.py"
  ];

  disabledTests = [
    # Blaxel SDK is unavailable.
    "test_blaxel_preflight_missing_auth"
    "test_blaxel_preflight_ok"

    # Requires network access.
    "test_relative_path_without_dot_slash_hints"

    # Installed distributions report "package", not "source".
    "test_install_source_uses_source_import_fallback"
  ]
  ++ lib.optionals (!ec2Support) [
    "test_ec2_preflight_no_ssh"
    "test_ec2_preflight_ok"
  ]
  ++ lib.optionals (!langsmithSupport) [
    "test_langsmith_preflight_missing_auth"
    "test_langsmith_preflight_ok_api_key"
    "test_langsmith_preflight_ok_profile"
    "test_run_delivers_nesting_handle_from_registry_into_env"
  ]
  ++ lib.optionals (!wandbSupport) [
    "test_wandb_preflight_rejects_invalid_credentials"
    "test_wandb_preflight_ok"
  ];

  pythonImportsCheck = [ "harbor" ];

  passthru.tests.viewer = runCommand "${finalAttrs.pname}-viewer-test" { } ''
    test -f "${finalAttrs.finalPackage}/${python.sitePackages}/harbor/viewer/static/index.html"
    test -d "${finalAttrs.finalPackage}/${python.sitePackages}/harbor/viewer/static/assets"
    touch $out
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    description = "Framework for evaluating and optimizing agents and models";
    homepage = "https://github.com/harbor-framework/harbor";
    changelog = "https://github.com/harbor-framework/harbor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.hobr ];
    mainProgram = "harbor";
    platforms = lib.platforms.unix;
  };
})
