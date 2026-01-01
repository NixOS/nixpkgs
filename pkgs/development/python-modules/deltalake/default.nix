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
<<<<<<< HEAD
  opentelemetry-api,
  opentelemetry-sdk,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  writableTmpDirAsHomeHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "deltalake";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-dqzkiWHeAbfXzEsaKyRiJx+0m/dIOMi9+gxjcuBT2QU=";
=======
    hash = "sha256-LpeJUNQg4FC73LX2LjvpPTMctRarTJsWlM8aeIfGPiU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
<<<<<<< HEAD
    hash = "sha256-MPwoGJ7xcsBRgaaM4jxhC6Vv2+Jhh0oYYtbji/Hc+vQ=";
=======
    hash = "sha256-4VmNhUijQMC/Wazcx+uT7mQqD+wutXrBJ+HN3AyxQRw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    writableTmpDirAsHomeHook
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

<<<<<<< HEAD
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
=======
  pythonImportsCheck = [ "deltalake" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    polars
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pytest-benchmark
    pytest-cov-stub
    pytest-mock
    pytest-timeout
<<<<<<< HEAD
  ]
  ++ lib.concatAttrValues optional-dependencies;
=======
    azure-storage-blob
    pyarrow
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  preCheck = ''
    # For paths in test to work, we have to be in python dir
    cd python

    # In tests we want to use deltalake that we have built
    rm -rf deltalake
  '';

<<<<<<< HEAD
  meta = {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kfollesdal
      mslingsby
      harvidsen
      andershus
    ];
  };
}
