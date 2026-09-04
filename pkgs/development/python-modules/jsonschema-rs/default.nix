{
  buildPythonPackage,
  cacert,
  fetchPypi,
  hypothesis,
  lib,
  nix-update-script,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "jsonschema-rs";
  version = "0.52.1";

  pyproject = true;

  # Fetching from Pypi, because there is no Cargo.lock in the GitHub repo.
  src = fetchPypi {
    inherit version;
    pname = "jsonschema_rs";
    hash = "sha256-JewdpSvBwRwBLhegG5fiTTOhXR12xwX9WnwnbRu+dnc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-kAV5tgTiT4+ccq8OtJPoy2PjQ5JjuND1VTJn8wZH4qw=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    # reqwest fails to build its HTTP client on Linux without a CA bundle
    # ("No CA certificates were loaded from the system").
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  # Need the official JSON Schema Test Suite, which is fetched as a git
  # submodule and not bundled in the sdist.
  disabledTestPaths = [
    "crates/jsonschema-py/tests-py/test_annotation_suite.py"
    "crates/jsonschema-py/tests-py/test_suite.py"
  ];

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
