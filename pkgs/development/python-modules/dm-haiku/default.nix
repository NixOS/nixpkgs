{ buildPythonPackage
, chex
, cloudpickle
, dill
, dm-tree
, fetchFromGitHub
, jaxlib
, jmp
, lib
, pytestCheckHook
, tabulate
, tensorflow
}:

buildPythonPackage rec {
  pname = "dm-haiku";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mdqjcka0m1div63ngba8w8z94id4c1h8xqmnq1xpmgkc79224wa";
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
    pytestCheckHook
    tensorflow
  ];

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
