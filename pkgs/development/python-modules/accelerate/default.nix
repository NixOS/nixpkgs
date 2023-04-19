{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, packaging
, psutil
, pyyaml
, torch
, evaluate
, parameterized
, pytest-subtests
, pytestCheckHook
, transformers
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.18.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "accelerate";
    rev = "refs/tags/v${version}";
    hash = "sha256-fCIvVbMaWAWzRfPc5/1CZq3gZ8kruuk9wBt8mzLHmyw=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    psutil
    pyyaml
    torch
  ];

  nativeCheckInputs = [
    evaluate
    parameterized
    pytest-subtests
    pytestCheckHook
    transformers
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export PATH="$out/bin:$PATH"
  '';

  pythonImportsCheck = [
    "accelerate"
  ];

  disabledTests = [
    # Requires access to HuggingFace to download checkpoints
    "test_infer_auto_device_map_on_t0pp"

    # Test needs to be updated for PyTorch 2.0
    "test_gradient_sync_cpu_multi"
  ];

  disabledTestPaths = [
    # Files under this path are used as scripts in tests,
    # and shouldn't be treated as pytest sources
    "src/accelerate/test_utils/scripts"

    # Requires access to HuggingFace to download checkpoints
    "tests/test_examples.py"
  ];

  meta = with lib; {
    description = "A simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    homepage = "https://github.com/huggingface/accelerate";
    license = licenses.asl20;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
