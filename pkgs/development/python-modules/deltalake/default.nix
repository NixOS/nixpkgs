{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pyarrow,
  pyarrow-hotfix,
  openssl,
  stdenv,
  libiconv,
  pkg-config,
  polars,
  pytestCheckHook,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-mock,
  pandas,
  azure-storage-blob,
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "0.25.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fz5Lg/z/EPJkdK4RcWHD8r3V9EwwwgRjwktri1IOdlY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-6SGVKJu01MzZxJv29PZKea+Z2YwAnvzbdDlnA4R6Az0=";
  };

  env.OPENSSL_NO_VENDOR = 1;

  dependencies = [
    pyarrow
    pyarrow-hotfix
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  nativeBuildInputs =
    [
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
    azure-storage-blob
  ];

  preCheck = ''
    # For paths in test to work, we have to be in python dir
    cp pyproject.toml python/
    cd python

    # In tests we want to use deltalake that we have built
    rm -rf deltalake
  '';

  pytestFlagsArray = [
    "--benchmark-disable"
    "-m 'not integration'"
  ];

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
