{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  protoc,

  # buildInputs
  protobuf,

  # dependencies
  pyarrow,
  typing-extensions,

  # tests
  arro3-core,
  nanoarrow,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datafusion";
  version = "53.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "datafusion-python";
    tag = finalAttrs.version;
    # Fetch arrow-testing and parquet-testing (tests assets)
    fetchSubmodules = true;
    hash = "sha256-3plgAJuh2rrnvzkQVy3gUgEoHHT4FSjDp5DZx1keD+g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-kHGlUaPNSs1Nh3HCU+yUVQq/IXp9PUwpDmfAon8eRBk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    protoc
  ];

  buildInputs = [
    protobuf
  ];

  dependencies = [
    pyarrow
    typing-extensions
  ];

  nativeCheckInputs = [
    arro3-core
    nanoarrow
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "datafusion"
    "datafusion._internal"
  ];

  preCheck = ''
    rm -rf python/datafusion
  '';

  disabledTests = [
    # Exception: DataFusion error (requires internet access)
    "test_register_http_csv"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: Failed: Query was not interrupted; got error: None
    "test_collect_interrupted"
  ];

  meta = {
    description = "Extensible query execution framework";
    longDescription = ''
      DataFusion is an extensible query execution framework, written in Rust,
      that uses Apache Arrow as its in-memory format.
    '';
    homepage = "https://arrow.apache.org/datafusion/";
    changelog = "https://github.com/apache/datafusion-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
