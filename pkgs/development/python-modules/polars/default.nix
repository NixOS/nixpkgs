{
  lib,
  stdenv,
  build,
  buildPythonPackage,
  cargo,
  cmake,
  fetchFromGitHub,
  pkg-config,
  pkgs, # zstd hidden by python3Packages.zstd
  pytestCheckHook,
  pytest-codspeed ? null, # Not in Nixpkgs
  pytest-cov-stub,
  pytest-xdist,
  pytest-benchmark,
  rustc,
  rustPlatform,
  runCommand,
  setuptools,
  mimalloc,
  jemalloc,
  rust-jemalloc-sys,
  # Another alternative is to try `mimalloc`
  polarsMemoryAllocator ? mimalloc, # polarsJemalloc,
  polarsJemalloc ?
    let
      jemalloc' = rust-jemalloc-sys.override {
        jemalloc = jemalloc.override {
          # "libjemalloc.so.2: cannot allocate memory in static TLS block"

          # https://github.com/pola-rs/polars/issues/5401#issuecomment-1300998316
          disableInitExecTls = true;
        };
      };
    in
    assert builtins.elem "--disable-initial-exec-tls" jemalloc'.configureFlags;
    jemalloc',

  polars,
  python,
}:

let
  version = "1.36.1";

  # Hide symbols to prevent accidental use
  rust-jemalloc-sys = throw "polars: use polarsMemoryAllocator over rust-jemalloc-sys";
  jemalloc = throw "polars: use polarsMemoryAllocator over jemalloc";
in

buildPythonPackage rec {
  pname = "polars";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    tag = "py-${version}";
    hash = "sha256-0usMg/xQZOzrLf2gIfNFtzj96cYVzq5gFaKTFLqyfK0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-20AI4AGSxnmYitQjfwTFwxMBplEqvN4WXPFdoqJBgSg=";
  };

  requiredSystemFeatures = [ "big-parallel" ];

  build-system = [
    setuptools
    build
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    cmake # libz-ng-sys
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [
    polarsMemoryAllocator
    (pkgs.__splicedPackages.zstd or pkgs.zstd)
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;

    # https://github.com/NixOS/nixpkgs/blob/5c38beb516f8da3a823d94b746dd3bf3c6b9bbd7/doc/languages-frameworks/rust.section.md#using-community-maintained-rust-toolchains-using-community-maintained-rust-toolchains
    # https://discourse.nixos.org/t/nixpkgs-rustplatform-and-nightly/22870
    RUSTC_BOOTSTRAP = true;

    RUSTFLAGS = lib.concatStringsSep " " (
      lib.optionals (polarsMemoryAllocator.pname == "mimalloc") [
        "--cfg allocator=\"mimalloc\""
      ]
    );
    RUST_BACKTRACE = true;
  };

  dontUseCmakeConfigure = true;

  maturinBuildFlags = [
    "-m"
    "py-polars/runtime/polars-runtime-32/Cargo.toml"
  ];

  # maturin builds `_polars_runtime_32`, and we also need the pure-python `polars` wheel itself
  preBuild = ''
    pyproject-build --no-isolation --outdir dist/ --wheel py-polars
  '';

  # Fails on polars -> polars-runtime-32 dependency between the two wheels
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [
    "polars"
  ];

  passthru.tests.dynloading-1 =
    runCommand "polars-dynloading-1"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            ps.pyarrow
            polars
          ]))
        ];
      }
      ''
        ((LD_DEBUG=libs python) |& tee $out | tail) << \EOF
        import pyarrow
        import polars
        EOF
        touch $out
      '';
  passthru.tests.dynloading-2 =
    runCommand "polars-dynloading-2"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            ps.pyarrow
            polars
          ]))
        ];
        failureHook = ''
          sed "s/^/    /" $out >&2
        '';
      }
      ''
        ((LD_DEBUG=libs python) |& tee $out | tail) << \EOF
        import polars
        import pyarrow
        EOF
      '';
  passthru.tests.pytest = stdenv.mkDerivation {
    pname = "${polars.pname}-pytest";

    inherit (polars) version src;

    requiredSystemFeatures = [ "big-parallel" ];

    sourceRoot = "${src.name}/py-polars";
    postPatch = ''
      for f in * ; do
        [[ "$f" == "tests" ]] || \
        [[ "$f" == "pyproject.toml" ]] || \
        rm -rf "$f"
      done
      for pat in "__pycache__" "*.pyc" ; do
        find -iname "$pat" -exec rm "{}" ";"
      done
    '';
    dontConfigure = true;
    dontBuild = true;

    doCheck = true;
    checkPhase = "pytestCheckPhase";
    nativeBuildInputs = [
      (python.withPackages (ps: [
        polars
        ps.aiosqlite
        ps.altair
        ps.boto3
        ps.deltalake
        ps.fastexcel
        ps.flask
        ps.flask-cors
        ps.fsspec
        ps.gevent
        ps.hypothesis
        ps.jax
        ps.jaxlib
        (ps.kuzu or null)
        ps.matplotlib
        ps.moto
        ps.nest-asyncio
        ps.numpy
        ps.openpyxl
        ps.orjson
        ps.pandas
        ps.pyarrow
        ps.pydantic
        ps.pyiceberg
        ps.sqlalchemy
        ps.torch
        ps.xlsx2csv
        ps.xlsxwriter
        ps.zstandard
        ps.cloudpickle
      ]))
    ];
    nativeCheckInputs = [
      pytestCheckHook
      pytest-codspeed
      pytest-cov-stub
      pytest-xdist
      pytest-benchmark
    ];

    pytestFlags = [
      "--benchmark-disable"
      "-nauto"
      "--dist=loadgroup"
    ];
    disabledTests = [
      "test_read_kuzu_graph_database" # kuzu
      "test_read_database_cx_credentials" # connectorx

      # adbc_driver_.*
      "test_write_database_append_replace"
      "test_write_database_create"
      "test_write_database_create_quoted_tablename"
      "test_write_database_adbc_temporary_table"
      "test_write_database_create"
      "test_write_database_append_replace"
      "test_write_database_errors"
      "test_write_database_errors"
      "test_write_database_create_quoted_tablename"

      # Internet access:
      "test_read_web_file"
      "test_run_python_snippets"

      # AssertionError: Series are different (exact value mismatch)
      "test_reproducible_hash_with_seeds"

      # AssertionError: assert 'PARTITIONED FORCE SPILLED' in 'OOC sort forced\nOOC sort started\nRUN STREAMING PIPELINE\n[df -> sort -> ordered_sink]\nfinished sinking into OOC so... sort took: 365.662µs\nstarted sort source phase\nsort source phase took: 2.169915ms\nfull ooc sort took: 4.502947ms\n'
      "test_streaming_sort"

      # AssertionError assert sys.getrefcount(foos[0]) == base_count (3 == 2)
      # tests/unit/dataframe/test_df.py::test_extension
      "test_extension"

      # Internet access (https://bucket.s3.amazonaws.com/)
      "test_scan_credential_provider"
      "test_scan_credential_provider_serialization"

      # Only connecting to localhost, but http URL scheme is disallowed
      "test_scan_delta_loads_aws_profile_endpoint_url"

      # ModuleNotFoundError: ADBC 'adbc_driver_sqlite.dbapi' driver not detected.
      "test_read_database"
      "test_read_database_parameterised_uri"

      # Untriaged
      "test_async_index_error_25209"
      "test_parquet_schema_correctness"
    ];
    disabledTestPaths = [
      "tests/benchmark"
      "tests/docs"

      # Internet access
      "tests/unit/io/cloud/test_credential_provider.py"

      # adbc
      "tests/unit/io/database/test_read.py"

      # Requires pydantic 2.12
      "tests/unit/io/test_iceberg.py"
    ];

    installPhase = "touch $out";
  };

  meta = {
    description = "Dataframes powered by a multithreaded, vectorized query engine, written in Rust";
    homepage = "https://github.com/pola-rs/polars";
    changelog = "https://github.com/pola-rs/polars/releases/tag/py-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      SomeoneSerge
    ];
    mainProgram = "polars";
    platforms = lib.platforms.all;
  };
}
