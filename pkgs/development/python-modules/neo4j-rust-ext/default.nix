{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  numpy,
  pandas,
  pyarrow,
  pytz,
  setuptools,
  rustPlatform,
  cargo,
  rustc,
  neo4j,
  pytestCheckHook,
  pytest-mock,
  pytest-benchmark,
}:
buildPythonPackage (finalAttrs: {
  pname = "neo4j-rust-ext";
  version = "6.3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neo4j";
    repo = "neo4j-python-driver-rust-ext";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-a7Dcn6mSbaXuqN1+CMaBYJbc5GmXaHulgNaexSVg46U=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = { };
  };

  build-system = [ rustPlatform.maturinBuildHook ];

  dependencies = [ neo4j ];

  optional-dependencies = {
    numpy = [ numpy ];
    pandas = [
      numpy
      pandas
    ];
    pyarrow = [ pyarrow ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-benchmark
  ];

  # The build only produces neo4j/_rust*.so (this package extends the neo4j
  # namespace package rather than shipping it), so it isn't importable on its
  # own until merged with the real neo4j package's files -- which is what
  # actually happens for real consumers via the Nix-generated PYTHONPATH/
  # withPackages merging, but not automatically inside this package's own
  # check phase. Build that merged view just for testing.
  preCheck = ''
    mkdir -p neo4j-test-env/neo4j
    cp -r --no-preserve=mode ${neo4j}/${python.sitePackages}/neo4j/. neo4j-test-env/neo4j/
    cp $out/${python.sitePackages}/neo4j/_rust*.so neo4j-test-env/neo4j/
    export PYTHONPATH="$PWD/neo4j-test-env:$PYTHONPATH"
  '';

  # driver/ is a vendored copy of the neo4j driver itself (see the
  # fetchSubmodules comment above); it has its own conftest.py that collides
  # with this package's tests/conftest.py if pytest collects both, so
  # restrict to this package's own tests.
  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # Requires a live Neo4j server to connect to.
    "tests/benchmarks/test_macro_benchmarks.py"
  ];

  disabledTests = [
    # Upstream bug: calls _mock_mask_extensions(mocker, ext) here, but the
    # function it imports (from tests/vector/from_driver/test_vector.py)
    # takes (ext, mocker) -- the swapped args make every case fail with
    # "Invalid ext value <MockerFixture ...>".
    # https://github.com/neo4j/neo4j-python-driver-rust-ext/issues/106
    "test_bench_swap_endian"
  ];

  pythonImportsCheck = [ "neo4j" ];

  meta = {
    description = "Rust Extensions for a Faster Neo4j Bolt Driver for Python";
    homepage = "https://github.com/neo4j/neo4j-python-driver-rust-ext";
    changelog = "https://github.com/neo4j/neo4j-python-driver-rust-ext/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
