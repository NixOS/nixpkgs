{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  airportsdata,
  cloudpickle,
  datasets,
  diskcache,
  genson,
  interegular,
  iso3166,
  jinja2,
  jsonschema,
  lark,
  nest-asyncio,
  numpy,
  outlines-core,
  pycountry,
  pydantic,
  referencing,
  requests,
  torch,
  transformers,

  # tests
  anthropic,
  google-genai,
  jax,
  llama-cpp-python,
  ollama,
  openai,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = "outlines";
    tag = version;
    hash = "sha256-t1YSkFC56De9HkdDJN9WIpKDdHxZRfGRbFOtAiJxKUI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    airportsdata
    cloudpickle
    datasets
    diskcache
    genson
    interegular
    iso3166
    jinja2
    jsonschema
    lark
    nest-asyncio
    numpy
    outlines-core
    pycountry
    pydantic
    referencing
    requests
    torch
    transformers
  ];

  pythonImportsCheck = [ "outlines" ];

  nativeCheckInputs = [
    anthropic
    google-genai
    jax
    llama-cpp-python
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
