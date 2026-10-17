{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pythonAtLeast,

  # buildInputs
  openssl,

  # nativeBuildInputs
  pkg-config,
  protobuf,

  # dependencies
  deprecation,
  lance-namespace,
  numpy,
  packaging,
  pyarrow,
  pydantic,
  tqdm,
  pythonOlder,
  overrides,

  # tests
  aiohttp,
  boto3,
  datafusion,
  duckdb,
  pandas,
  polars,
  pylance,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  tantivy,
}:

buildPythonPackage (finalAttrs: {
  pname = "lancedb";
  version = "0.40.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6L6ayJJaL8nhO+ep9Us1zq+bYDaUashVjmzW1ji8yAk=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-aNTHrXC8Zheg5NG8Ew+jQNRcNLmZeVznzQqQgzRo9+s=";
  };

  # `lance-linalg`'s AVX-512 VNNI u8-distance kernels call `_mm512_dpbusd_epi32` /
  # `_mm512_dpwssd_epi32`. With the current toolchain, stdarch's signature for these intrinsics
  # mismatches LLVM's `llvm.x86.avx512.vpdpbusd.512`, so the crate fails to compile.
  # Drop the AVX-512 VNNI dispatch branch: the kernels then become dead code (their module is
  # crate-private and otherwise only used from `#[cfg(test)]`, which is not built for
  # dependencies), so they are never codegen'd and runtime dispatch falls back to the equivalent
  # AVX2 / scalar kernels.
  postPatch = ''
    lanceDistance=("$cargoDepsCopy"/source-registry-0/lance-linalg-*/src/distance)

    substituteInPlace "$lanceDistance/dot_u8.rs" \
      --replace-fail "return |a, b| unsafe { x86::dot_u8_avx512_vnni(a, b) };" ""

    substituteInPlace "$lanceDistance/l2_u8.rs" \
      --replace-fail "return |a, b| unsafe { x86::l2_u8_avx512_vnni(a, b) };" ""

    substituteInPlace "$lanceDistance/cosine_u8.rs" \
      --replace-fail "return |a, b| unsafe { x86::cosine_u8_accum_avx512_vnni(a, b) };" ""
  ''
  # Same for `lance-index`'s pairwise BQ/SQ kernels: make their AVX-512 VNNI dispatch
  # statically false so that the scalar fallbacks are always used.
  + ''
    lanceVector=("$cargoDepsCopy"/source-registry-0/lance-index-*/src/vector)

    substituteInPlace "$lanceVector/bq/pairwise.rs" \
      --replace-fail "if simd && *x86::HAS_AVX512_VNNI {" "if false {"

    substituteInPlace "$lanceVector/sq/pairwise.rs" \
      --replace-fail "dim <= MAX_BATCHED_DIM && has_vnni" "false && dim <= MAX_BATCHED_DIM && has_vnni" \
      --replace-fail "if self.batched {" "if false {"
  '';

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
  ];

  dependencies = [
    deprecation
    lance-namespace
    numpy
    packaging
    pyarrow
    pydantic
    tqdm
  ]
  ++ lib.optionals (pythonOlder "3.12") [
    overrides
  ];

  pythonImportsCheck = [ "lancedb" ];

  nativeCheckInputs = [
    aiohttp
    boto3
    datafusion
    duckdb
    pandas
    polars
    pylance
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    tantivy
  ];

  preCheck = ''
    cd python/python/tests
  '';

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    # Requires internet access
    # RuntimeError: lance error: LanceError(IO): Generic S3 error
    "test_bucket_without_dots_is_not_rejected"
    # RuntimeError: lance error: LanceError(IO): Generic HTTP client error
    "test_bucket_with_dots_and_aws_region_is_not_rejected"
    "test_bucket_with_dots_and_region_is_not_rejected"

    # lance_namespace.errors.UnsupportedOperationError: Not supported: create_empty_table
    "TestAsyncNamespaceConnection"
    "TestNamespaceConnection"

    # Failed: DID NOT RAISE <class 'Exception'>
    "test_merge_insert"

    # Flaky: writes a module next to an already-imported one without invalidating the import caches
    # ModuleNotFoundError: No module named 'fx_uses_local'
    "test_local_module_outside_code_warns_at_registration"

    # Runs `python -I` in a subprocess, which ignores PYTHONPATH:
    # ModuleNotFoundError: No module named 'pyarrow'
    "test_shared_helpers_construct_state_on_every_path"

    # TypeError: FFILanceTableProvider.__datafusion_table_provider__() missing 1 required positional
    # argument: 'session'
    "test_sql_query"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Converting Pydantic type to Arrow Type: unsupported type
    # <class 'test_pydantic.test_optional_nested_model.<locals>.WALocation'>.
    "test_optional_nested_model"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky (even when the sandbox is disabled):
    # FileNotFoundError: [Errno 2] Cannot delete directory '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts':
    # Cannot get information for path '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts/.tmppyKXfw'
    "test_create_index_from_table"
  ]
  ++ lib.optionals ((pythonAtLeast "3.14") && stdenv.hostPlatform.isDarwin) [
    # Failed: DID NOT RAISE <class 'Exception'>
    "test_merge_insert"
  ];

  disabledTestPaths = [
    # touch the network
    "test_namespace_integration.py"
    "test_s3.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
    "test_remote_db.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Developer-friendly, serverless vector database for AI applications";
    homepage = "https://github.com/lancedb/lancedb";
    changelog = "https://github.com/lancedb/lancedb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
