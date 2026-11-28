{
  buildPythonPackage,
  cacert,
  fetchPypi,
  hypothesis,
  lib,
  nix-update-script,
  pytestCheckHook,
  rustPlatform,
  pkg-config,
  aws-lc,
}:

buildPythonPackage rec {
  pname = "jsonschema-rs";
  version = "0.61.2";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "jsonschema_rs";
    hash = "sha256-jqI2STRQwBPwldXU2dO45W+gFT+zBRB/mnE06ha89Ws=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-nNu8ZJGRXyQ6I0INfKDWo7u/t9O0qrb//TRk0rfr0dQ=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    # reqwest fails to build its HTTP client on Linux without a CA bundle
    # ("No CA certificates were loaded from the system").
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

    # conftest.py imports `jsonschema_testsuite_pyo3`, a test-only extension
    # module built from a crate that is not shipped in the sdist. An empty
    # stub satisfies the import; the tests that use it are disabled below.
    mkdir -p "$TMPDIR/testsuite-stub"
    touch "$TMPDIR/testsuite-stub/jsonschema_testsuite_pyo3.py"
    export PYTHONPATH="$TMPDIR/testsuite-stub:$PYTHONPATH"
  '';

  # Need the official JSON Schema Test Suite, which is fetched as a git
  # submodule and not bundled in the sdist.
  disabledTestPaths = [
    "crates/jsonschema-py/tests-py/test_annotation_suite.py"
    "crates/jsonschema-py/tests-py/test_suite.py"
  ];

  # Require the real `jsonschema_testsuite_pyo3` module (see preCheck).
  disabledTests = [ "codegen" ];

  pythonImportsCheck = [ "jsonschema_rs" ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance JSON Schema validator for Python";
    homepage = "https://github.com/Stranger6667/jsonschema/tree/master/crates/jsonschema-py";
    changelog = "https://github.com/Stranger6667/jsonschema/blob/python-v${version}/crates/jsonschema-py/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DutchGerman
      friedow
    ];
  };
}
