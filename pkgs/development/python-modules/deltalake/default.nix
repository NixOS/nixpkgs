{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  arro3-core,
  pyarrow,
  openssl,
  stdenv,
  libiconv,
  opentelemetry-api,
  opentelemetry-sdk,
  pkg-config,
  polars,
  pytestCheckHook,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pandas,
  deprecated,
  azure-storage-blob,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "1.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q67k+TJQHmZtSf3cIUEf79fx9q3t34+c3v61yxb+6ag=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-M6P2Tx5NQ19YUIBJ8afOgI4rfyb4FjbhOThQoQMsMiM=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  dependencies = [
    arro3-core
    deprecated
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config # openssl-sys needs this
    writableTmpDirAsHomeHook
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  optional-dependencies = {
    pandas = [ pandas ];
    pyarrow = [ pyarrow ];
  };

  pythonImportsCheck = [ "deltalake" ];

  nativeCheckInputs = [
    azure-storage-blob
    opentelemetry-api
    opentelemetry-sdk
    polars
    pytestCheckHook
    pytest-benchmark
    pytest-cov-stub
    pytest-mock
    pytest-timeout
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    # For paths in test to work, we have to be in python dir
    cd python

    # In tests we want to use deltalake that we have built
    rm -rf deltalake
  '';

  meta = {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kfollesdal
      mslingsby
      harvidsen
      andershus
    ];
  };
}
