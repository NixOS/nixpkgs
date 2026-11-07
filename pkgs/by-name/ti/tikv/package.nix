{
  lib,
  stdenv,
  symlinkJoin,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  cargo,
  pkg-config,
  cmake,
  openssl,
  snappy,
  lz4,
  zstd,
  enableFramePointer ? true,
  enableDefaultTestEngines ? true,
  enableAsyncBacktrace ? true,
  # optional: different malloc implementations
  withJemalloc ? true,
  withTcmalloc ? false,
  withSnmalloc ? false,
  reproducibleBuild ? true,
}:

# NOTE: We have to work around tons of Rust breaking changes
# since TiKV v8.5.5 is pinned to Rust 1.77 nightly.
# Wait for https://github.com/tikv/tikv/pull/19464 to remove patches.

let
  # Required for prometheus crate with "nightly" feature
  rustcWithLibSrc = buildPackages.rustc.override {
    sysroot = symlinkJoin {
      name = "rustc_unwrapped_with_libsrc";
      paths = [
        buildPackages.rustc.unwrapped
      ];
      postBuild = ''
        mkdir -p $out/lib/rustlib/src/rust
        ln -s ${rustPlatform.rustLibSrc} $out/lib/rustlib/src/rust/library
      '';
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "tikv";
  version = "8.5.5";

  src = fetchFromGitHub {
    owner = "tikv";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-1SGfzCnZh9d+k0YHkXHw5lSYvz4o6LD+96jnUdnN5S4=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd "$out"

      git rev-parse HEAD 2> /dev/null > TIKV_BUILD_GIT_HASH
      git rev-parse --abbrev-ref HEAD 2> /dev/null > TIKV_BUILD_GIT_BRANCH

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  patches = [
    ./0001-build-bump-time-crate-for-Rust-1.80-compatibility.patch
    ./0002-file_system-adapt-try_lock-return-type.patch
    ./0003-tikv_kv-replace-opaque-snapshot-futures-with-BoxFutu.patch
    ./0004-config-adapt-Vec-extract_if-signature-for-Rust-1.91.patch
    ./0005-backup-stream-use-slice-chunk_by.patch
    ./0006-rust-squash-let-chain-compatibility-fixes.patch
  ];

  cargoDeps = symlinkJoin {
    name = "tikv-cargodeps";
    paths = [
      (rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        patches = finalAttrs.patches;
        hash = "sha256-MfgH8NLs6FirGENZJq8ddKQZXdHUK68+ugS0u4r+/Ug=";
      })
    ];
    # Pull in rust vendor so we don't have to vendor rustLibSrc again.
    # This is required because `-Z build-std=...` rebuilds std.
    postBuild = ''
      cp -rsn ${rustPlatform.rustVendorSrc}/* $out/*/
    '';
  };

  dontUseCmakeConfigure = true;

  # `$cargoDepsCopy` is unstable across nixpkgs versions
  postPatch = ''
    # Suppress CMake 4.1 incompatibility error with <3.5
    sed -i 's/cmake_minimum_required(VERSION 3\\.4 FATAL_ERROR)/cmake_minimum_required(VERSION 3.5)/' \
      $cargoDepsCopy/*/libdbus-sys-*/vendor/dbus/CMakeLists.txt

    # Build with `-std=c++17`
    substituteInPlace $cargoDepsCopy/*/grpcio-sys-*/grpc/CMakeLists.txt \
      --replace-fail "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 17)"

    # Suppress `-Werror`
    substituteInPlace $cargoDepsCopy/*/librocksdb_sys-*/rocksdb/CMakeLists.txt \
      --replace-fail 'option(FAIL_ON_WARNINGS "Treat compile warnings as errors" ON)' 'option(FAIL_ON_WARNINGS "Treat compile warnings as errors" OFF)'

    # Fix relative path between crates
    substituteInPlace $cargoDepsCopy/*/libtitan_sys-0.0.1/build.rs \
      --replace-fail 'cur_dir.join("..").join("rocksdb")' 'cur_dir.join("..").join("librocksdb_sys-0.1.0").join("rocksdb")'
  '';

  nativeBuildInputs = [
    cargo
    rustcWithLibSrc
    rustc.llvmPackages.lld
    pkg-config
    cmake
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
  ];

  buildInputs = [
    openssl
    snappy.dev
    lz4.dev
    zstd.dev
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "memory-engine"
  ]
  ++ lib.optionals enableDefaultTestEngines [
    "test-engine-kv-rocksdb"
    "test-engine-raft-raft-engine"
  ]
  ++ lib.optional enableAsyncBacktrace "trace-async-tasks"
  ++ lib.optional (!stdenv.isDarwin) "portable"
  ++ lib.optional (!stdenv.isAarch64) "sse"
  ++ lib.optional enableFramePointer "pprof-fp"
  ++ lib.optional withTcmalloc "tcmalloc"
  ++ lib.optional withJemalloc "jemalloc"
  ++ lib.optional withSnmalloc "snmalloc"
  ++ lib.optional stdenv.isLinux "mem-profiling";
  cargoBuildType = "release";

  cargoBuildFlags = lib.optionals enableFramePointer [
    "-Z build-std=core,std,alloc,proc_macro,test"
    "-Z unstable-options"
  ];

  preBuild = ''
    export TIKV_BUILD_RUSTC_VERSION=$(rustc --version 2> /dev/null)
    export TIKV_BUILD_GIT_HASH=$(<TIKV_BUILD_GIT_HASH)
    export TIKV_BUILD_GIT_TAG=${finalAttrs.src.tag}
    export TIKV_BUILD_GIT_BRANCH=$(<TIKV_BUILD_GIT_BRANCH)
  ''
  + lib.optionalString reproducibleBuild ''
    export SOURCE_DATE_EPOCH=315532800
    export TIKV_BUILD_TIME=$(date -d "@$SOURCE_DATE_EPOCH")
  '';

  doCheck = false; # TODO: investigate
  env = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5"; # Fix build with CMake 4.1

    TIKV_FRAME_POINTER = toString enableFramePointer; # Optionally enable pprof-fp
    TIKV_ENABLE_FEATURES = lib.concatStringsSep " " finalAttrs.buildFeatures;
    TIKV_PROFILE = finalAttrs.cargoBuildType;

    RUSTC_BOOTSTRAP = true; # Enable nightly Rust features
    CARGO_BUILD_PIPELINING = "true";
    OPENSSL_NO_VENDOR = true; # Use OpenSSL from nixpkgs

    ROCKSDB_SYS_PORTABLE = true;
    ROCKSDB_SYS_SSE = if stdenv.isAarch64 then "0" else "1";
    ENABLE_FIPS = "0";

    NIX_ENFORCE_NO_NATIVE = if reproducibleBuild then "1" else "0";

    RUSTFLAGS =
      let
        target = stdenv.hostPlatform.config;
        targetFlags = lib.fix (self: {
          build = lib.optional enableFramePointer "-Cforce-frame-pointers=yes" ++ [
            "-Adangerous_implicit_autorefs" # Rust 1.89 https://github.com/rust-lang/rust/pull/141661
          ];

          "aarch64-unknown-linux-gnu" = self.build ++ [
            "-Ctarget-feature=-outline-atomics"
          ];
        });
      in
      lib.concatStringsSep " " (lib.attrsets.attrByPath [ target ] targetFlags.build targetFlags);

    CFLAGS = lib.concatStringsSep " " (
      lib.optionals enableFramePointer [
        "-fno-omit-frame-pointer"
        "-mno-omit-leaf-frame-pointer"
      ]
      ++ lib.optionals stdenv.isDarwin [
        "-Wno-error=vla"
        "-Wno-vla-extension"
      ]
    );

    CXXFLAGS = lib.concatStringsSep " " (
      [
        "-std=c++17"
        "-include cstdint" # `<cstdint>` not included in abseil-cpp
      ]
      ++ lib.optionals enableFramePointer [
        "-fno-omit-frame-pointer"
        "-mno-omit-leaf-frame-pointer"
      ]
      ++ lib.optionals stdenv.isDarwin [
        "-Wno-error=vla"
        "-Wno-vla-extension"
      ]
    );
  };

  meta = {
    description = "Distributed transactional key-value database, originally created to complement TiDB";
    longDescription = ''
      TiKV is an open-source, distributed, and transactional key-value database.
      Unlike other traditional NoSQL systems, TiKV not only provides classical
      key-value APIs, but also transactional APIs with ACID compliance. Built in
      Rust and powered by Raft, TiKV was originally created by PingCAP to
      complement TiDB, a distributed HTAP database compatible with the MySQL protocol.
    '';
    license = lib.licenses.asl20;
    homepage = "https://github.com/tikv/tikv";
    mainProgram = "tikv-server";
    maintainers = [ lib.maintainers.definfo ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
