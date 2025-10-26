{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  cloudpickle,
  datasets,
  diskcache,
  genson,
  interegular,
  jinja2,
  jsonschema,
  lark,
  nest-asyncio,
  numpy,
  outlines-core,
  pycountry,
  pydantic,
  torch,
  transformers,

  # tests
  airportsdata,
  anthropic,
  google-genai,
  iso3166,
  jax,
  llama-cpp-python,
  mistralai,
  ollama,
  openai,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "1.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = "outlines";
    tag = version;
    hash = "sha256-QuS8IokiOPJeh59+W4FLoE9dvBCChf2li70+Ex3aIwg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "outlines_core"
  ];
  dependencies = [
    cloudpickle
    datasets
    diskcache
    genson
    interegular
    jinja2
    jsonschema
    lark
    nest-asyncio
    numpy
    outlines-core
    pycountry
    pydantic
    torch
    transformers
  ];

  # llama_cpp dependency cannot be imported when cudaSupport is enabled as it tries to load libcuda.so.1.
  # This library is provided by the nvidia driver at runtime, but isn't available in the sandbox.
  pythonImportsCheck = lib.optionals (!config.cudaSupport) [
    "outlines"
  ];
  # We also have to give up on tests for the same reason.
  doCheck = !config.cudaSupport;

  nativeCheckInputs = [
    airportsdata
    anthropic
    google-genai
    iso3166
    jax
    llama-cpp-python
    mistralai
    ollama
    openai
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    tensorflow
  ];

  pytestFlagsArray = [
    # FutureWarning: functools.partial will be a method descriptor in future Python versions; wrap it in enum.member() if you want to preserve the old behavior
    "-Wignore::FutureWarning"
  ];

  disabledTests = [
    # Try to dowload models from Hugging Face Hub
    "test_application_callable_call"
    "test_application_generator_reuse"
    "test_application_template_call"
    "test_application_template_error"
    "test_generator_black_box_async_processor"
    "test_generator_black_box_sync_processor"
    "test_generator_init_multiple_output_type"
    "test_generator_steerable_output_type"
    "test_generator_steerable_processor"
    "test_llamacpp_type_adapter_format_output_type"
    "test_steerable_generator_call"
    "test_steerable_generator_init_cfg_output_type"
    "test_steerable_generator_init_invalid_output_type"
    "test_steerable_generator_init_other_output_type"
    "test_steerable_generator_init_valid_processor"
    "test_steerable_generator_stream"
    "test_transformer_tokenizer_convert_token_to_string"
    "test_transformer_tokenizer_decode"
    "test_transformer_tokenizer_encode"
    "test_transformer_tokenizer_eq"
    "test_transformer_tokenizer_getstate_setstate"
    "test_transformer_tokenizer_hash"
    "test_transformer_tokenizer_init"

    # TypeError: "Could not resolve authentication method.
    # Expected either api_key or auth_token to be set.
    # Or for one of the `X-Api-Key` or `Authorization` headers to be explicitly omitted.
    "test_anthopic_streaming"
    "test_anthropic_chat"
    "test_anthropic_simple_call"
    "test_anthropic_simple_vision"

    # ConnectionError: Failed to connect to Ollama.
    "test_ollama_async_chat"
    "test_ollama_async_direct"
    "test_ollama_async_json"
    "test_ollama_async_simple"
    "test_ollama_async_simple_vision"
    "test_ollama_async_stream"
    "test_ollama_async_stream_json"
    "test_ollama_chat"
    "test_ollama_direct"
    "test_ollama_json"
    "test_ollama_simple"
    "test_ollama_simple_vision"
    "test_ollama_stream"
    "test_ollama_stream_json"

    # openai.APIConnectionError: Connection error.
    "test_openai_async_chat"
    "test_openai_async_direct_call"
    "test_openai_async_simple_call"
    "test_openai_async_simple_call_multiple_samples"
    "test_openai_async_simple_json_schema"
    "test_openai_async_simple_pydantic"
    "test_openai_async_simple_pydantic_refusal"
    "test_openai_async_simple_vision"
    "test_openai_async_simple_vision_pydantic"
    "test_openai_async_streaming"
    "test_openai_chat"
    "test_openai_direct_call"
    "test_openai_simple_call"
    "test_openai_simple_call_multiple_samples"
    "test_openai_simple_json_schema"
    "test_openai_simple_pydantic"
    "test_openai_simple_pydantic_refusal"
    "test_openai_simple_vision"
    "test_openai_simple_vision_pydantic"
    "test_openai_streaming"

    # RuntimeError: Mistral API error: [Errno -3] Temporary failure in name resolution
    "test_mistral_async_call"
    "test_mistral_async_call_model_name"
    "test_mistral_async_chat"
    "test_mistral_async_json_schema"
    "test_mistral_async_multiple_samples"
    "test_mistral_async_pydantic"
    "test_mistral_async_pydantic_refusal"
    "test_mistral_async_streaming"
    "test_mistral_async_vision"
    "test_mistral_async_vision_pydantic"
    "test_mistral_call"
    "test_mistral_call_model_name"
    "test_mistral_chat"
    "test_mistral_json_schema"
    "test_mistral_multiple_samples"
    "test_mistral_pydantic"
    "test_mistral_pydantic_refusal"
    "test_mistral_streaming"
    "test_mistral_vision"
    "test_mistral_vision_pydantic"
  ];

  disabledTestPaths = [
    # Try to dowload models from Hugging Face Hub
    "tests/backends/test_backends.py"
    "tests/backends/test_llguidance.py"
    "tests/backends/test_outlines_core.py"
    "tests/backends/test_xgrammar.py"
    "tests/models/test_llamacpp.py"
    "tests/models/test_llamacpp_tokenizer.py"
    "tests/models/test_transformers.py"
    "tests/models/test_transformers_multimodal.py"
    "tests/models/test_transformers_multimodal_type_adapter.py"
    "tests/models/test_transformers_type_adapter.py"

    # Requires unpackaged dottxt
    "tests/models/test_dottxt.py"

    # ValueError: Missing key inputs argument! To use the Google AI API, provide (`api_key`) arguments.
    "tests/models/test_gemini.py"
  ];

  meta = {
    description = "Structured text generation";
    homepage = "https://github.com/outlines-dev/outlines";
    changelog = "https://github.com/dottxt-ai/outlines/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
  };
}
