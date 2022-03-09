{ buildPythonPackage
, fetchFromGitHub
, jaxlib
, keras
, lib
, matplotlib
, msgpack
, numpy
, optax
, pytestCheckHook
, tensorflow
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rvdaxyf68qmm5d77gbizpcibyz2ic2pb2x7rgf7p8qwijyc39ws";
  };

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    matplotlib
    msgpack
    numpy
    optax
  ];

  pythonImportsCheck = [
    "flax"
  ];

  checkInputs = [
    keras
    pytestCheckHook
    tensorflow
  ];

  disabledTestPaths = [
    # Docs test, needs extra deps + we're not interested in it.
    "docs/_ext/codediff_test.py"

    # The tests in `examples` are not designed to be executed from a single test
    # session and thus either have the modules that conflict with each other or
    # wrong import paths, depending on how they're invoked. Many tests also have
    # dependencies that are not packaged in `nixpkgs` (`clu`, `jgraph`,
    # `tensorflow_datasets`, `vocabulary`) so the benefits of trying to run them
    # would be limited anyway.
    "examples/*"
  ];

  meta = with lib; {
    description = "Neural network library for JAX";
    homepage = "https://github.com/google/flax";
    license = licenses.asl20;
    maintainers = with maintainers; [ ndl ];
  };
}
