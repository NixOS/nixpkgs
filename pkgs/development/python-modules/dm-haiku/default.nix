{ buildPythonPackage
, chex
, cloudpickle
, dill
, dm-tree
, fetchFromGitHub
, jaxlib
, jmp
, lib
, pytest-xdist
, pytestCheckHook
, tabulate
, tensorflow
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qvKMeGPiWXvvyV+GZdTWdsC6Wp08AmP8nDtWk7sZtqM=";
  };

  propagatedBuildInputs = [
    jmp
    tabulate
  ];

  checkInputs = [
    chex
    cloudpickle
    dm-tree
    jaxlib
    pytest-xdist
    pytestCheckHook
    tensorflow
  ];
  pytestFlagsArray = [ "-n $NIX_BUILD_CORES" ];

  pythonImportsCheck = [
    "haiku"
  ];

  disabledTestPaths = [
    # These tests require `bsuite` which isn't packaged in `nixpkgs`.
    "examples/impala_lite_test.py"
    "examples/impala/actor_test.py"
    "examples/impala/learner_test.py"
    # This test breaks on multiple cases with TF-related errors,
    # likely that's the reason the upstream uses TF-nightly for tests?
    # `nixpkgs` doesn't have the corresponding TF version packaged.
    "haiku/_src/integration/jax2tf_test.py"
  ];

  meta = with lib; {
    description = "Haiku is a simple neural network library for JAX developed by some of the authors of Sonnet.";
    homepage = "https://github.com/deepmind/dm-haiku";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
