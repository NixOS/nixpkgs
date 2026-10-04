{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  makePythonPath,
  python,
  rustPlatform,
  rustc,
  stdenv,
  unzip,
  versionCheckHook,
  ast-grep,
  difftastic,
  scc,
  ast-grep-cli,
  anthropic,
  click,
  cryptography,
  datasets,
  fastapi,
  fastembed,
  h2,
  hnswlib,
  httpx,
  jinja2,
  langchain-ollama,
  litellm,
  magika,
  mcp,
  numpy,
  ollama,
  onnxruntime,
  openai,
  openpyxl,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  orjson,
  pillow,
  pydantic,
  pytest-asyncio,
  pytest-cov,
  pytestCheckHook,
  pyyaml,
  rapidocr,
  respx,
  rich,
  scikit-learn,
  sentence-transformers,
  sentencepiece,
  socksio,
  sqlite-vec,
  tiktoken,
  tomlkit,
  torch,
  trafilatura,
  transformers,
  tree-sitter,
  tree-sitter-language-pack,
  uvicorn,
  watchdog,
  websockets,
  xlrd,
  xlwt,
  zstandard,
}:

let
  dependencies = [
    ast-grep-cli
    anthropic
    click
    datasets
    fastapi
    fastembed
    h2
    httpx
    jinja2
    litellm
    magika
    mcp
    numpy
    onnxruntime
    openai
    openpyxl
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    orjson
    pillow
    pydantic
    pyyaml
    rapidocr
    rich
    scikit-learn
    sentence-transformers
    sentencepiece
    sqlite-vec
    tiktoken
    tomlkit
    torch
    trafilatura
    transformers
    tree-sitter
    tree-sitter-language-pack
    uvicorn
    watchdog
    websockets
    xlrd
    zstandard
  ];

  bundledTools = [
    ast-grep
    difftastic
    scc
  ];

  tiktokenEncodings = linkFarm "tiktoken-encodings" [
    {
      name = "0ea1e91bbb3a60f729a8dc8f777fd2fc07cd8df4";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken";
        hash = "sha256-MGzSfwPBpxTspxCOA9ZrfcBCq+jCWLRMGZp+2YON2TA=";
      };
    }
    {
      name = "ec7223a39ce59f226a68acc30dc1af2788490e15";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/p50k_base.tiktoken";
        hash = "sha256-lLXKff9NAHZ7wlb90bJ+Wxc2HXuKX5aFR/nyPrcNIGk=";
      };
    }
    {
      name = "9b5ad71b2ce5302211f9c61530b329a4922fc6a4";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken";
        hash = "sha256-Ijkht27pm96ZW3/3OFE+7xAPtR0YyTWXoRO8/+hlsqc=";
      };
    }
    {
      name = "fb374d419588a4632f3f557e76b4b70aebbca790";
      path = fetchurl {
        url = "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken";
        hash = "sha256-RGqVOMtsNI41FhINfAiwn1fDZJXirP/+WaW/iwz7Gi0=";
      };
    }
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "headroom-ai";
  version = "0.39.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "headroomlabs-ai";
    repo = "headroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pcsKKq27cKyB7uWskbnWP8VI/UU9RdrE89QClLisvcU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-azHjTfjdARzYuDMdH1AOYn0YV9U9lzaoULcSC/a9MuE=";
  };

  build-system = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  # The upstream [all] extra covers every supported runtime feature.
  inherit dependencies;

  makeWrapperArgs = [
    # Proxy startup re-execs `python -m headroom.cli`; preserve its package closure for that child interpreter.
    "--prefix"
    "PYTHONPATH"
    ":"
    "$out/${python.sitePackages}:${makePythonPath dependencies}"

    # Make the bundled tools available.
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath bundledTools)

    # Use bundled Tiktoken encodings instead of lazily downloading them.
    "--set"
    "TIKTOKEN_CACHE_DIR"
    tiktokenEncodings
  ];

  pythonImportsCheck = [ "headroom" ];

  disabledTests = [
    # These tests cover service/process management or platform behavior untestable in the test sandbox.
    "test_bash_native_installer_supports_persistent_docker_lifecycle"
    "test_bash_native_wrapper_supports_opencode"
    "test_device_authorization_uses_form_encoded_request"
    "test_device_poll_uses_form_encoded_request"
    "test_dynamic_detector_import_skips_optional_ml_dependencies"
    "test_ensure_proxy_dependencies_exits_when_fastapi_missing"
    "test_exchange_token_sync_raises_for_http_error"
    "test_install_supervisor_darwin_windows_and_unsupported"
    "test_ordinary_install_does_not_adopt_serena"
    "test_proxy_command_exits_when_mcp_missing"
    "test_quiesce_turns_config_is_honored"
    "test_readyz_excludes_kompress_from_aggregate_readiness"
    "test_readyz_keeps_pending_kompress_unloaded"
    "test_readyz_kompress_state_matrix"
    "test_readyz_never_calls_lazy_kompress_getters"
    "test_replayed_marker_is_not_rebooked_in_the_emitted_savings"
    "test_run_server_uses_selector_loop_on_windows"
    "test_runtime_start_lock_blocks_another_process"
    "test_sighup_on_launch_tool_reaps_the_proxy"
    "test_verbatim_read_never_cache_written_before_maturation"
    # These tests download a SentenceTransformer model from Hugging Face, which is unavailable in the sandbox.
    "test_cpu_embed_workers_are_thread_capped"
    "test_cpu_uses_dedicated_thread_capped_executor"
    "test_embed_batch"
    "test_embed_single"
    "test_similar_texts_have_high_similarity"
    # These tests require Hugging Face datasets or models not bundled with the package.
    "test_batch_efficiency"
    "test_benchmark_loads"
    "test_compression_achieved"
    "test_extraction_f1_full"
    "test_extraction_f1_medium"
    "test_extraction_f1_quick"
    "test_hybrid_scoring"
    "test_import_export_preserves_facts"
    "test_paraphrase_match"
    "test_semantic_match"
    # The route is claimed by the generic proxy when the optional gateway contract is disabled.
    "test_contract_disabled_by_env"
    # Nix creates tmp_path below /build, which the watcher treats as an ignored directory.
    # Its main.py event never reaches _schedule_reindex(), so `scheduled == [\"reindex\"]` fails.
    "test_code_graph_watcher_init_start_stop_and_event_filtering"
  ];

  # LiteLLM 1.81.12 does not contain this upstream test's expected Groq model price.
  pytestFlags = [
    "--deselect=tests/test_pricing_from_litellm.py::test_provider_prices_models_its_table_never_covered[groq/llama-guard-3-8b-0.2-0.2]"
  ];

  nativeCheckInputs = [
    cryptography
    hnswlib
    langchain-ollama
    ollama
    pytest-asyncio
    pytest-cov
    pytestCheckHook
    respx
    socksio
    xlwt
  ]
  ++ bundledTools
  ++ [
    unzip
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/headroom";

  preCheck = ''
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    # Fail fast for optional Hugging Face models, which cannot be downloaded in the test sandbox.
    export HF_HUB_OFFLINE=1
    export TRANSFORMERS_OFFLINE=1

    # Tiktoken lazily downloads its OpenAI encoding files. Use Nix-fetched copies in the test sandbox.
    export TIKTOKEN_CACHE_DIR=${tiktokenEncodings}

    # The upstream health probe and SSRF guard cannot reach the mock upstream hosts in the test sandbox.
    export HEADROOM_SKIP_UPSTREAM_CHECK=1
    export HEADROOM_ALLOWED_BASE_URLS=httpbin.org,api.deepseek.com,opencode.ai

    # Use LiteLLM's bundled price map; the test sandbox has no network access.
    export LITELLM_LOCAL_MODEL_COST_MAP=True

    # Pytest imports the source tree first, so expose maturin's built extension from the wheel.
    # Extract the full wheel because the extension's platform-specific filename is not stable across targets.
    unzip -o "$dist"/*.whl -d .

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # The global fixture scrubs HEADROOM_* settings; retain only these sandbox values for their affected tests.
      substituteInPlace tests/conftest.py --replace-fail '
      def _scrub_developer_headroom_env(monkeypatch, tmp_path):
          for key in list(os.environ):
              if key.startswith("HEADROOM_"):
      ' '
      def _scrub_developer_headroom_env(request, monkeypatch, tmp_path):
          sandbox_proxy_tests = (
              "tests/test_hermes_passthrough_compression.py",
              "tests/test_proxy/test_anthropic_upstream_header.py",
              "tests/test_proxy/test_openai_transport_path_prefix.py",
              "tests/test_proxy_ccr.py",
          )
          preserve_sandbox_proxy_env = str(request.node.path).endswith(sandbox_proxy_tests)
          for key in list(os.environ):
              if key.startswith("HEADROOM_") and not (
                  preserve_sandbox_proxy_env
                  and key in {"HEADROOM_ALLOWED_BASE_URLS", "HEADROOM_SKIP_UPSTREAM_CHECK"}
              ):
      '
    ''}
  '';

  meta = {
    description = "Context optimization layer for LLM applications";
    homepage = "https://github.com/headroomlabs-ai/headroom";
    license = lib.licenses.asl20;
    mainProgram = "headroom";
    maintainers = with lib.maintainers; [ attila ];
  };
})
