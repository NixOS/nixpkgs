{
  lib,
  buildPythonPackage,
  rustPlatform,
  testers,
  pysail,
  sail,

  protoc,
  protobuf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysail";
  inherit (sail) version src cargoDeps; # nixpkgs-update: no auto update
  pyproject = true;

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

  passthru.tests.version = testers.testVersion {
    package = pysail;
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
