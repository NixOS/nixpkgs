{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  testers,
  pysail,

  protoc,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysail";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lakehq";
    repo = "sail";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EX8cDed32uF7NSreViKBn7RQeWIG7C7sI6O0c+hVf4M=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-ouNXKPpwKTLfI+Gcp393r7oHZAjUFQL9225+AuFzdoo=";
  };

  # The `generate-import-lib` PyO3 feature only matters when building Windows
  # import libraries; on other platforms it just pulls in the `python3-dll-a`
  # crate, which is not vendored. Drop it so the offline maturin build resolves.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"pyo3/generate-import-lib",' ""
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protoc
  ];

  buildInputs = [
    protobuf
  ];

  pythonImportsCheck = [
    "pysail"
    "pysail._native"
  ];

  # The test suite requires a running Spark Connect server and many
  # heavyweight optional dependencies (pyspark-client, duckdb, ...).
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = pysail;
    };
  };

  meta = {
    description = "Python bindings for Sail, a Spark-compatible compute engine on Apache Arrow and DataFusion";
    homepage = "https://github.com/lakehq/sail";
    changelog = "https://github.com/lakehq/sail/blob/${finalAttrs.src.tag}/docs/reference/changelog/index.md";
    license = lib.licenses.asl20;
    mainProgram = "sail";
    maintainers = [ lib.maintainers.davidlghellin ];
  };
})
