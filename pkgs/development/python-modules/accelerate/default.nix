{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, numpy
, packaging
, psutil
, pyyaml
, torch
, evaluate
, parameterized
, transformers
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.18.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fCIvVbMaWAWzRfPc5/1CZq3gZ8kruuk9wBt8mzLHmyw=";
  };

  nativeBuildInputs = [ setuptools ];

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
    pytestCheckHook
    transformers
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';
  pytestFlagsArray = [ "tests" ];
  disabledTests = [
    # try to download data:
    "FeatureExamplesTests"
    "test_infer_auto_device_map_on_t0pp"
    # known failure with Torch>2.0; see https://github.com/huggingface/accelerate/pull/1339:
    # (remove for next release)
    "test_gradient_sync_cpu_multi"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # usual aarch64-linux RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
    "CheckpointTest"
  ];
  # numerous instances of torch.multiprocessing.spawn.ProcessRaisedException:
  doCheck = !stdenv.isDarwin;
  pythonImportsCheck = [
    "accelerate"
  ];

  meta = with lib; {
    homepage = "https://huggingface.co/docs/accelerate";
    description = "A simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    changelog = "https://github.com/huggingface/accelerate/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "accelerate";
  };
}
