{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  #  build-system
  setuptools,

  # dependencies
  filelock,
  huggingface-hub,
  importlib-metadata,
  numpy,
  pillow,
  regex,
  requests,
  safetensors,

  # optional dependencies
  accelerate,
  datasets,
  flax,
  jax,
  jaxlib,
  jinja2,
  peft,
  protobuf,
  tensorboard,
  torch,

  # tests
  writeText,
  parameterized,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  requests-mock,
  scipy,
  sentencepiece,
  torchsde,
  transformers,
  pythonAtLeast,
  diffusers,
}:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.35.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "diffusers";
    tag = "v${version}";
    hash = "sha256-2qiaPQVJco1oVvwILfYh0nx0hOgG7Hus2eeWTWjTQQc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    pillow
    regex
    requests
    safetensors
  ];

  optional-dependencies = {
    flax = [
      flax
      jax
      jaxlib
    ];
    torch = [
      accelerate
      torch
    ];
    training = [
      accelerate
      datasets
      jinja2
      peft
      protobuf
      tensorboard
    ];
  };

  pythonImportsCheck = [ "diffusers" ];

  # it takes a few hours
  doCheck = false;

  nativeCheckInputs = [
    parameterized
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    requests-mock
    scipy
    sentencepiece
    torchsde
    transformers
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck =
    let
      # This pytest hook mocks and catches attempts at accessing the network
      # tests that try to access the network will raise, get caught, be marked as skipped and tagged as xfailed.
      # cf. python3Packages.shap
      conftestSkipNetworkErrors = writeText "conftest.py" ''
        from _pytest.runner import pytest_runtest_makereport as orig_pytest_runtest_makereport
        import urllib3

        class NetworkAccessDeniedError(RuntimeError): pass
        def deny_network_access(*a, **kw):
          raise NetworkAccessDeniedError

        urllib3.connection.HTTPSConnection._new_conn = deny_network_access

        def pytest_runtest_makereport(item, call):
          tr = orig_pytest_runtest_makereport(item, call)
          if call.excinfo is not None and call.excinfo.type is NetworkAccessDeniedError:
              tr.outcome = 'skipped'
              tr.wasxfail = "reason: Requires network access."
          return tr
      '';
    in
    ''
      export HOME=$(mktemp -d)
      cat ${conftestSkipNetworkErrors} >> tests/conftest.py
    '';

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # depends on current working directory
    "test_deprecate_stacklevel"
    # fails due to precision of floating point numbers
    "test_full_loop_no_noise"
    "test_model_cpu_offload_forward_pass"
    # tries to run ruff which we have intentionally removed from nativeCheckInputs
    "test_is_copy_consistent"

    # Require unpackaged torchao:
    # importlib.metadata.PackageNotFoundError: No package metadata was found for torchao
    "test_load_attn_procs_raise_warning"
    "test_save_attn_procs_raise_warning"
    "test_save_load_lora_adapter_0"
    "test_save_load_lora_adapter_1"
    "test_wrong_adapter_name_raises_error"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # RuntimeError: Dynamo is not supported on Python 3.12+
    "test_from_save_pretrained_dynamo"
  ];

  passthru.tests.pytest = diffusers.overridePythonAttrs { doCheck = true; };

  meta = {
    description = "State-of-the-art diffusion models for image and audio generation in PyTorch";
    mainProgram = "diffusers-cli";
    homepage = "https://github.com/huggingface/diffusers";
    changelog = "https://github.com/huggingface/diffusers/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
