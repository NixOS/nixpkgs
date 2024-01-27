{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, writeText
, setuptools
, wheel
, filelock
, huggingface-hub
, importlib-metadata
, numpy
, pillow
, regex
, requests
, safetensors
# optional dependencies
, accelerate
, datasets
, flax
, jax
, jaxlib
, jinja2
, peft
, protobuf
, tensorboard
, torch
# test dependencies
, parameterized
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, requests-mock
, scipy
, sentencepiece
, torchsde
, transformers
}:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.25.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "diffusers";
    rev = "refs/tags/v${version}";
    hash = "sha256-AvD/kiwKGojsLlJ0n/U6tTu7ON8Ujl0lZd1e/fDY+CM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    pillow
    regex
    requests
    safetensors
  ];

  passthru.optional-dependencies = {
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

  pythonImportsCheck = [
    "diffusers"
  ];

  # tests crash due to torch segmentation fault
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

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
  ] ++ passthru.optional-dependencies.torch;

  preCheck = let
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
  in ''
    export HOME=$TMPDIR
    cat ${conftestSkipNetworkErrors} >> tests/conftest.py
  '';

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    # depends on current working directory
    "test_deprecate_stacklevel"
    # fails due to precision of floating point numbers
    "test_model_cpu_offload_forward_pass"
    # tries to run ruff which we have intentionally removed from nativeCheckInputs
    "test_is_copy_consistent"
  ];

  meta = with lib; {
    description = "State-of-the-art diffusion models for image and audio generation in PyTorch";
    homepage = "https://github.com/huggingface/diffusers";
    changelog = "https://github.com/huggingface/diffusers/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
