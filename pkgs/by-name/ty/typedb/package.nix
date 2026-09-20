{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  lz4,
  zlib,
  zstd,
  bzip2,
  snappy,
  testers,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typedb";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "typedb";
    repo = "typedb";
    tag = finalAttrs.version;
    hash = "sha256-wlu6WPLWfMvuk4cNTBNv7ugtlK3sU5r2DXuEHcaCk9o=";
  };

  # importCargoLock (real `cargo vendor` with full git trees) rather than
  # fetchCargoVendor: the vendored git checkouts keep sibling directories
  # (typedb-protocol's build script compiles ../../proto/*.proto), which
  # subtree-copy vendoring drops. Git revisions pinned with fixed-output
  # hashes; recompute after any lock change touching them.
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typedb-protocol-0.0.0" = "sha256-vP1UttrPyKzFnE6b3/b5sA+vyld29/sEP82E2+hChic=";
      "typeql-0.0.0" = "sha256-ZoXQhzAvexROIhg/8hr9yR01aJqumDeC7FNkpBP/o/E=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    # tonic-build (server/service/admin/proto) needs protoc at build time.
    protobuf
    # librocksdb-sys runs bindgen at build time; the hook provides libclang.
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    # RocksDB (storage) C++ compression dependencies.
    lz4
    zlib
    zstd
    bzip2
    snappy
  ];

  PROTOC = "${protobuf}/bin/protoc";

  # Unit suites only: lib/bins are hermetic, while the process-spawning
  # integration suites (assembly, behaviour, crash recovery) need excluded
  # infrastructure. Narrowed with evidence from remote builds.
  doCheck = true;
  checkFlags = [
    "--locked"
    "--lib"
    "--bins"
  ];

  postInstall = ''
    mv $out/bin/typedb_server_bin $out/bin/typedb-server
    mkdir -p $out/share/typedb
    cp $src/server/config.yml $out/share/typedb/config.yml.example
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "typedb-server --version";
    version = finalAttrs.version;
  };

  meta = {
    description = "Strongly-typed database with a rich and logical type system";
    homepage = "https://typedb.com";
    license = lib.licenses.mpl20;
    mainProgram = "typedb-server";
    maintainers = with lib.maintainers; [ caniko ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
