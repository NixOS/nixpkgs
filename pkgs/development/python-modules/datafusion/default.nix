{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pythonOlder,

  # nativeBuildInputs
  protoc,

  # buildInputs
  protobuf,

  # dependencies
  cloudpickle,
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
  # WARNING: Ensure rerun-sdk is compatible with this version of datafusion
  version = "55.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    name = "datafusion-source";
    owner = "apache";
    repo = "datafusion-python";
    tag = finalAttrs.version;
    # Fetch arrow-testing and parquet-testing (tests assets)
    fetchSubmodules = true;
    hash = "sha256-IMCMdqOrenmHA06V2Cb/wuQw95Vg+5ozGrG96lxkTuc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-l1c/drkxnFjYc3PztSP62rTcTM3EH1rDcxaR7nSVkmI=";
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
    cloudpickle
    pyarrow
  ]
  ++ lib.optionals (pythonOlder "3.13") [
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
