{
  lib,
  stdenv,
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
  version = "1.27.1";

  # Hide symbols to prevent accidental use
  rust-jemalloc-sys = throw "polars: use polarsMemoryAllocator over rust-jemalloc-sys";
  jemalloc = throw "polars: use polarsMemoryAllocator over jemalloc";
in

buildPythonPackage rec {
  pname = "polars";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    tag = "py-${version}";
    hash = "sha256-/VigBBjZglPleXB9jhWHtA+y7WixjboVbzslprZ/A98=";
  };

  # Do not type-check assertions because some of them use unstable features (`is_none_or`)
  postPatch = ''
    while IFS= read -r -d "" path ; do
      sed -i 's \(\s*\)debug_assert! \1#[cfg(debug_assertions)]\n\1debug_assert! ' "$path"
    done < <( find -iname '*.rs' -print0 )
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dbPhEMhfe8DZO1D8U+3W1goNK1TAVyLzXHwXzzRvASw=";
  };

  requiredSystemFeatures = [ "big-parallel" ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    cargo
    pkg-config
    cmake # libz-ng-sys
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
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

    # Several `debug_assert!` statements use the unstable `Option::is_none_or` method
    RUSTFLAGS = lib.concatStringsSep " " (
      [
        "-Cdebug_assertions=n"
      ]
      ++ lib.optionals (polarsMemoryAllocator.pname == "mimalloc") [
        "--cfg use_mimalloc"
      ]
    );
    RUST_BACKTRACE = true;
  };

  dontUseCmakeConfigure = true;

  maturinBuildFlags = [
    "-m"
    "py-polars/Cargo.toml"
  ];

  postInstall = ''
    # Move polars.abi3.so -> polars.so
    local polarsSo=""
    local soName=""
    while IFS= read -r -d "" p ; do
      polarsSo=$p
      soName="$(basename "$polarsSo")"
      [[ "$soName" == polars.so ]] && break
    done < <( find "$out" -iname "polars*.so" -print0 )
    [[ -z "''${polarsSo:-}" ]] && echo "polars.so not found" >&2 && exit 1
    if [[ "$soName" != polars.so ]] ; then
      mv "$polarsSo" "$(dirname "$polarsSo")/polars.so"
    fi
  '';

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

    pytestFlagsArray = [
      "--benchmark-disable"
      "-n auto"
      "--dist loadgroup"
      ''-m "slow or not slow"''
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

      # ModuleNotFoundError: ADBC 'adbc_driver_sqlite.dbapi' driver not detected.
      "test_read_database"
      "test_read_database_parameterised_uri"

      # Untriaged
      "test_pickle_lazyframe_nested_function_udf"
      "test_serde_udf"
      "test_hash_struct"
    ];
    disabledTestPaths = [
      "tests/benchmark"
      "tests/docs"

      # Internet access
      "tests/unit/io/cloud/test_credential_provider.py"

      # Wrong altair version
      "tests/unit/operations/namespaces/test_plot.py"

      # adbc
      "tests/unit/io/database/test_read.py"

      # Untriaged
      "tests/unit/cloud/test_prepare_cloud_plan.py"
      "tests/unit/io/cloud/test_cloud.py"
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
