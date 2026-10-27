{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,
  libiconv,

  # dependencies
  arro3-core,
  deprecated,

  # optional-dependencies
  pandas,
  pyarrow,

  # tests
  arro3-io,
  azure-storage-blob,
  cacert,
  opentelemetry-api,
  opentelemetry-sdk,
  polars,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deltalake";
  version = "1.6.6";
  pyproject = true;
  __structuredAttrs = true;

  # The GitHub repository does not ship a Cargo.lock
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kYZNl620KfqLh0i09o1pras9BBf/qfEAvbhYBYkMmX8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-PELrTQyjD+Rqh+kco57WahmpW/qBykd/3MVbejHsozk=";
  };

  # maturin >= 1.13 skips adding `-undefined dynamic_lookup` on darwin as it finds it in
  # python/.cargo/config.toml, which cargo never reads (it runs from the source root).
  # https://github.com/NixOS/nixpkgs/issues/541257
  postPatch = ''
    rm -r python/.cargo
  '';

  env = {
    OPENSSL_NO_VENDOR = 1;
    # Previously set in python/.cargo/config.toml
    JEMALLOC_SYS_WITH_MALLOC_CONF = "dirty_decay_ms:500,muzzy_decay_ms:1000";
  }
  # Support 64K page kernels, as upstream does for its wheels
  # https://github.com/delta-io/delta-rs/issues/4413
  // lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) {
    JEMALLOC_SYS_WITH_LG_PAGE = 16;
  };

  nativeBuildInputs = [
    pkg-config # openssl-sys needs this
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  dependencies = [
    arro3-core
    deprecated
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    pyarrow = [ pyarrow ];
  };

  pythonImportsCheck = [ "deltalake" ];

  nativeCheckInputs = [
    arro3-io
    azure-storage-blob
    # The OpenDAL backends need CA certificates to build their HTTP client
    cacert
    opentelemetry-api
    opentelemetry-sdk
    polars
    pytest-benchmark
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # Flaky: compares a µs-precision start time with the ms-truncated file modificationTime
    #   AssertionError: assert 1792660007.508148 < 1792660007.508
    "test_nanosecond_timestamps_cast_to_microsecond_by_default"
  ];

  # For paths in tests to work, we have to be in the python directory.
  # Also remove the source package so that tests use the built one.
  preCheck = ''
    cd python
    rm -rf deltalake
  '';

  meta = {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/python-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kfollesdal
      mslingsby
      harvidsen
      andershus
    ];
  };
})
