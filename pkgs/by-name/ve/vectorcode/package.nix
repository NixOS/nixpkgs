{
  lib,
  cargo,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  protobuf,
  python3,
  rustc,
  rustPlatform,
  versionCheckHook,

  lspSupport ? true,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      # https://github.com/Davidyz/VectorCode/pull/36
      chromadb = super.chromadb.overridePythonAttrs (old: rec {
        version = "0.6.3";
        src = fetchFromGitHub {
          owner = "chroma-core";
          repo = "chroma";
          tag = version;
          hash = "sha256-yvAX8buETsdPvMQmRK5+WFz4fVaGIdNlfhSadtHwU5U=";
        };
        cargoDeps = rustPlatform.fetchCargoVendor {
          pname = "chromadb";
          inherit version src;
          hash = "sha256-lHRBXJa/OFNf4x7afEJw9XcuDveTBIy3XpQ3+19JXn4=";
        };
        postPatch = null;
        build-system = with self; [
          setuptools
          setuptools-scm
        ];
        nativeBuildInputs = [
          cargo
          pkg-config
          protobuf
          rustc
          rustPlatform.cargoSetupHook
        ];
        dependencies = old.dependencies ++ [
          self.chroma-hnswlib
        ];

        # The base package disables additional tests, so explicitly override
        disabledTests = [
          # Tests are flaky / timing sensitive
          "test_fastapi_server_token_authn_allows_when_it_should_allow"
          "test_fastapi_server_token_authn_rejects_when_it_should_reject"

          # Issue with event loop
          "test_http_client_bw_compatibility"

          # httpx ReadError
          "test_not_existing_collection_delete"
        ];

        disabledTestPaths = [
          # Tests require network access
          "chromadb/test/auth/test_simple_rbac_authz.py"
          "chromadb/test/db/test_system.py"
          "chromadb/test/ef/test_default_ef.py"
          "chromadb/test/property/"
          "chromadb/test/property/test_cross_version_persist.py"
          "chromadb/test/stress/"
          "chromadb/test/test_api.py"

          # httpx failures
          "chromadb/test/api/test_delete_database.py"

          # Cannot be loaded by pytest without path hacks (fixed in 1.0.0)
          "chromadb/test/test_logservice.py"
          "chromadb/test/proto/test_utils.py"
          "chromadb/test/segment/distributed/test_protobuf_translation.py"

          # Hypothesis FailedHealthCheck due to nested @given tests
          "chromadb/test/cache/test_cache.py"

          # Tests fail when running in parallel.
          # E.g. when building the building python 3.12 and 3.13 versions simultaneously.
          # ValueError: An instance of Chroma already exists for ephemeral with different settings
          "chromadb/test/test_chroma.py"
          "chromadb/test/test_client.py"
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "vectorcode";
  version = "0.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Davidyz";
    repo = "VectorCode";
    tag = version;
    hash = "sha256-N74XBQahUIj0rKJI0emtNvGlG9uYkeHqweppp8fUSLU=";
  };

  build-system = with python.pkgs; [
    pdm-backend
  ];

  dependencies =
    with python.pkgs;
    [
      chromadb
      colorlog
      httpx
      json5
      numpy
      pathspec
      psutil
      pygments
      python-dotenv
      sentence-transformers
      shtab
      tabulate
      transformers
      tree-sitter
      tree-sitter-language-pack
    ]
    ++ lib.optionals lspSupport optional-dependencies.lsp;

  optional-dependencies = with python.pkgs; {
    intel = [
      openvino
      optimum
    ];
    legacy = [
      numpy
      torch
      transformers
    ];
    lsp = [
      lsprotocol
      pygls
    ];
    mcp = [
      mcp
      pydantic
    ];
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    $out/bin/vectorcode --print-completion=bash >vectorcode.bash
    $out/bin/vectorcode --print-completion=zsh >vectorcode.zsh
    installShellCompletion vectorcode.{bash,zsh}
  '';

  postFixup = ''
    wrapProgram $out/bin/vectorcode \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set PATH ${
        lib.makeBinPath [
          python
        ]
      };
  '';

  pythonImportsCheck = [ "vectorcode" ];

  nativeCheckInputs =
    [
      versionCheckHook
    ]
    ++ (with python.pkgs; [
      mcp
      pygls
      pytestCheckHook
    ]);
  versionCheckProgramArg = "version";

  disabledTests = [
    # Require internet access
    "test_get_embedding_function"
    "test_get_embedding_function_fallback"
    "test_get_reranker"
    "test_supported_rerankers_initialization"
  ];

  passthru = {
    # Expose these overridden inputs for debugging
    inherit python;
    inherit (python.pkgs) chromadb;
  };

  meta = {
    description = "Code repository indexing tool to supercharge your LLM experience";
    homepage = "https://github.com/Davidyz/VectorCode";
    changelog = "https://github.com/Davidyz/VectorCode/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "vectorcode";
    badPlatforms = [
      # Error in cpuinfo: failed to parse the list of possible processors in /sys/devices/system/cpu/possible
      # Error in cpuinfo: failed to parse the list of present processors in /sys/devices/system/cpu/present
      # Error in cpuinfo: failed to parse both lists of possible and present processors
      # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
      #   what():  /build/source/include/onnxruntime/core/common/logging/logging.h:371 static const onnxruntime::logging::Logger& onnxruntime::logging::LoggingManager::DefaultLogger() Attempt to use DefaultLogger but none has been registered.
      #
      # Since 0.7.4, disabling `pythonImportsCheck` and `pytestCheckPhase` is not enough anymore.
      # The error above happens at the end of `pypaInstallPhase`.
      "aarch64-linux"
    ];
  };
}
