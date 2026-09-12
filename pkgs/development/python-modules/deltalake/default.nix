{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  rustPlatform,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,

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
  pytestCheckHook,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deltalake";
  version = "1.6.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = "delta-rs";
    tag = "python-v${finalAttrs.version}";
    hash = "sha256-m6VeJ0zsAxSfmkDnMeOEObZYjVsIMoumv2CQWi9hOrQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";
  cargoRoot = "..";

  # Upstream does not commit `Cargo.lock`.
  # Regenerate it with `cargo generate-lockfile` at the root of the repository.
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "buoyant_kernel-0.24.0" = "sha256-axaOU2JLSOPwK6Ia3bS0Vw4hZplkdJlyNoIYES8CkXs=";
    };
  };

  postPatch =
    # Only `sourceRoot` is made writable, but the lock file belongs to the workspace root and the
    # test suite copies (mode-preserving) fixtures from `../crates/test/tests/data`.
    ''
      chmod -R u+w ..
      ln -s ${./Cargo.lock} ../Cargo.lock
    '';

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config # openssl-sys needs this
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    openssl
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
    opentelemetry-api
    opentelemetry-sdk
    polars
    pytestCheckHook
    pytest-benchmark
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck =
    # In tests we want to use the deltalake that we have built
    ''
      rm -rf deltalake
    ''
    # `rustls-platform-verifier` panics when it cannot load any CA certificate,
    # even for object stores that never hit the network (`tests/test_opendal.py`)
    + ''
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    '';

  # Upstream also collects doctests from the (removed) `deltalake` source directory
  enabledTestPaths = [ "tests" ];

  # The repository also holds `rust-v*` tags for the Rust crates
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=python-v(.*)"
    ];
  };

  meta = {
    description = "Native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    changelog = "https://github.com/delta-io/delta-rs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kfollesdal
      mslingsby
      harvidsen
      andershus
    ];
  };
})
