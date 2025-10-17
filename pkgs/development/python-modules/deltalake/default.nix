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
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "1.1.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LpeJUNQg4FC73LX2LjvpPTMctRarTJsWlM8aeIfGPiU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-4VmNhUijQMC/Wazcx+uT7mQqD+wutXrBJ+HN3AyxQRw=";
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
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  pythonImportsCheck = [ "deltalake" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    polars
    pytest-benchmark
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    azure-storage-blob
    pyarrow
  ];

  preCheck = ''
    # For paths in test to work, we have to be in python dir
    cd python

    # In tests we want to use deltalake that we have built
    rm -rf deltalake
  '';

  meta = with lib; {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kfollesdal
      mslingsby
      harvidsen
      andershus
    ];
  };
}
