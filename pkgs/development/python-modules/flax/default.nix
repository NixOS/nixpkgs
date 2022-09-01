{ buildPythonPackage
, fetchFromGitHub
, jaxlib
, jax
, keras
, lib
, matplotlib
, msgpack
, numpy
, optax
, pytest-xdist
, pytestCheckHook
, tensorflow
, fetchpatch
, rich
}:

buildPythonPackage rec {
  pname = "flax";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-egTYYFZxhE/Kk7jXRi1HmjCjyFia2LoRigH042isDu0=";
  };

  patches = [
    # Bump rich dependency, should be fixed in releases after 0.6.0
    # https://github.com/google/flax/pull/2407
    (fetchpatch {
      url = "https://github.com/google/flax/commit/72189153f9779022b97858ae747c23fbaf571e3d.patch";
      sha256 = "sha256-hKOn/M7qpBM6R1RIJpnXpRoZgIHqkwQZApN4L0fBzIE=";
      name = "bump_rich_dependency.patch";
    })
  ];

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    jax
    matplotlib
    msgpack
    numpy
    optax
    rich
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

  pytestFlagsArray = [
    "-W ignore::FutureWarning"
    "-W ignore::DeprecationWarning"
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
