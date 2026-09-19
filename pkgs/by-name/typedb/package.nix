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

  cargoHash = "sha256-/sSNWMagtomilssh7aSRQtlqOWwyF89FVtDpY5D4T5A=";

  nativeBuildInputs = [
    pkg-config
    # tonic-build (server/service/admin/proto) needs protoc at build time.
    protobuf
  ];

  buildInputs = [
    # RocksDB (storage) C++ compression dependencies. The `bindgen-runtime`
    # feature uses pre-generated bindings, so no libclang is required.
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
