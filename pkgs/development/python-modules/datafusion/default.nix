{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "50.1.0";
=======
  version = "50.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "arrow-datafusion-python";
    tag = version;
    # Fetch arrow-testing and parquet-testing (tests assets)
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-+r3msFc9yu3aJBDRI66A/AIctCbLxfZB3Ur/raDV3x8=";
=======
    hash = "sha256-to1GJQqI4aJOW8pGhWvU44ePrRo0cgeNwEGRJlb9grM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src version;
<<<<<<< HEAD
    hash = "sha256-XJ2x/EtMZu/fdS6XB/IydMfHmlaxEWJ3XJPY73WoGqs=";
=======
    hash = "sha256-ZACp7bBLYKmuZVAWEa2YxoCbQqwALv2bWf+zz6jbV9w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: Failed: Query was not interrupted; got error: None
    "test_collect_interrupted"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
