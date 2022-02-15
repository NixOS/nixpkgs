{ lib
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, fetchFromGitHub

# Native build inputs
, cython
, which

# Build inputs
, pybind11

# Propagated build inputs
, cffi
, hydra
, numpy
, pytorch
, regex
, sacrebleu
, tqdm
, dataclasses

# Check inputs
, pytestCheckHook
#, apex
}:

buildPythonPackage rec {
  pname = "fairseq";
  version = "0.10.2";

  # Pypi source package doesn't contain tests
  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "fairseq";
    rev = "v${version}";
    sha256 = "sha256:0k3lihngpy22mr6vgnvfmp7ngs91xijs24m64s7205lx3lyv7maq";
  };

  disabled = ! (pythonAtLeast "3.6");

  nativeBuildInputs = [
    cython
    which
  ];

  buildInputs = [
    pybind11
  ];

  propagatedBuildInputs = [
    cffi
    hydra
    numpy
    pytorch
    regex
    sacrebleu
    tqdm
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    pytestCheckHook
    # apex
  ];

  pythonImportsCheck = [ "fairseq" ];

  postPatch =
    ''
      substituteInPlace setup.py \
        --replace '"dataclasses"' "'dataclasses; python_version<\"3.7\"'"
    '';

  disabledTestPaths = [
    # FIXME: these megatron tests import the optional nvidia apex package
    "fairseq/model_parallel/megatron/mpu/tests/test_cross_entropy.py"
    "fairseq/model_parallel/megatron/mpu/tests/test_data.py"
    "fairseq/model_parallel/megatron/mpu/tests/test_initialize.py"
    "fairseq/model_parallel/megatron/mpu/tests/test_layers.py"
    "fairseq/model_parallel/megatron/mpu/tests/test_random.py"
  ];

  meta = with lib; {
    description = "Facebook AI Research Sequence-to-Sequence Toolkit";
    homepage = "https://github.com/pytorch/fairseq";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    broken = true; # A large number of tests are still failing
  };
}
