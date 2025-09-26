{
  lib,
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
  numpy,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "datafusion";
  version = "49.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    tag = version;
    # Fetch arrow-testing and parquet-testing (tests assets)
    fetchSubmodules = true;
    hash = "sha256-U3LRZQMjL8sNa5yQmwfhw9NRGC0299TRODylzZkvFh4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
    hash = "sha256-lCbqy6kZK+LSLvr+Odxt167ACnDap2enH/J4ILcPtOc=";
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
  ];

  meta = {
    description = "Extensible query execution framework";
    longDescription = ''
      DataFusion is an extensible query execution framework, written in Rust,
      that uses Apache Arrow as its in-memory format.
    '';
    homepage = "https://arrow.apache.org/datafusion/";
    changelog = "https://github.com/apache/arrow-datafusion-python/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
