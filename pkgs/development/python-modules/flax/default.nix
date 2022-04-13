{ buildPythonPackage
, fetchFromGitHub
, jaxlib
, keras
, lib
, matplotlib
, msgpack
, numpy
, optax
, pytest-xdist
, pytestCheckHook
, tensorflow
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j5ngdndm9nm49gcda7m36qzwk5lcbi4jnij9fi96vld54ip6f6v";
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
    pytest-xdist
    pytestCheckHook
    tensorflow
  ];
  pytestFlagsArray = [ "-n $NIX_BUILD_CORES -W ignore::FutureWarning" ];

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
