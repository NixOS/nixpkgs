{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  swi-prolog,
  libjwt,
  rustPlatform,
  cargo,
  gmp,
  mpfr,
  libmpc,
  protobuf,
  pkg-config,
  callPackage,
  applyPatches,
}:
let
  tusVersion = "0.0.16";
  jwt_ioVersion = "1.0.4";

  tus = fetchFromGitHub {
    owner = "terminusdb";
    repo = "tus";
    tag = "v${tusVersion}";
    hash = "sha256-NQGvDFtGEXhSXIZ7dZ2r13q8hRpYXkA9/NlFKED1ANM=";
  };

  jwt_io = applyPatches {
    src = fetchFromGitHub {
      owner = "terminusdb-labs";
      repo = "jwt_io";
      tag = "v${jwt_ioVersion}";
      hash = "sha256-YywD0zg4ft075AaxgNDOuxVxQSsQjP0BXTW5YLl2TS0=";
    };
    # TODO: remove if/when merged upstream https://github.com/terminusdb-labs/jwt_io/pull/2
    patches = [
      # Remove problematic ECDSA384 and ECDSA512 tests that segfault due to OpenSSL/libjwt version incompatibilities
      (fetchpatch2 {
        url = "https://github.com/terminusdb-labs/jwt_io/commit/f2c7066fb8a7d4a16c0b5ce8ccb3086270524976.patch?full_index=1";
        hash = "sha256-A/eonL4MhkJ1L0dBoaiITcE0kTWlkFslpPj377WbdnM=";
      })
      # SWI-Prolog 9.2 makes PL_register_foreign type checks strict; cast to pl_function_t
      (fetchpatch2 {
        url = "https://github.com/terminusdb-labs/jwt_io/commit/6bd0f2674eefcf80bfd3d1ca465b7af28efdc54e.patch?full_index=1";
        hash = "sha256-EacqYO9ulD6PUxT3gg6PEtQNmwenuKfxdv1a/2IA3wI=";
      })
      # Allow unresolved SWI-Prolog symbols to resolve at load time on Darwin
      (fetchpatch2 {
        url = "https://github.com/terminusdb-labs/jwt_io/commit/dbb11e74566e25b7b942c1cbd4742bd485cc6bf5.patch?full_index=1";
        hash = "sha256-BPg28msT3zevNsB4yJeFUai5uW5DgilfESXw32h2gSA=";
      })
    ];
  };

  swi-prologWithDeps =
    (swi-prolog.overrideAttrs (
      finalSwi-prologAttrs: previousAttrs: {
        pname = "terminusdb-swi-prolog";
        nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ pkg-config ];
        buildInputs = previousAttrs.buildInputs ++ [ libjwt ];
      }
    )).override
      {
        extraPacks = map (dep-path: "'file://${dep-path}'") [
          tus
          jwt_io
        ];
      };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "terminusdb";
  version = "12.0.2";

  src = fetchFromGitHub {
    owner = "terminusdb";
    repo = "terminusdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l573Drc76KSUXxhdleU/IBscDTul8VtgkZdrRPvNuNc=";
    leaveDotGit = true;
    postFetch = ''
      # Will be used for `TERMINUSDB_GIT_HASH`
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-zF506S4SiWx/uYyN2Trm4XPVUIU2K/qoNSjfKthLVuw=";
  };

  # TODO: remove if/when merged upstream https://github.com/terminusdb/terminusdb/pull/2360
  patches = [
    # Avoid building bundled GMP/MPFR/MPC in gmp-mpfr-sys during the Rust build
    (fetchpatch2 {
      url = "https://github.com/terminusdb/terminusdb/commit/b84dc6b28ef3fd0ef76db2cf7f69537b95af07cc.patch?full_index=1";
      hash = "sha256-L3U/MHZgMSoXIy6j+1+gKKY2+2obKgaJ3HdJOoMe2Sw=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    (with rustPlatform; [
      cargoSetupHook
      bindgenHook # provides libclang
    ])
    cargo
    protobuf
    swi-prologWithDeps
  ];

  buildInputs = [
    swi-prologWithDeps
    gmp
    mpfr
    libmpc
  ];

  # Darwin: gmp-mpfr-sys (use-system-libs) runs raw `$CC ... -lgmp` probes without
  # propagating `CFLAGS`/`CPPFLAGS`, so we must provide include/lib paths via
  # compiler-native env vars
  # https://gitlab.com/tspiteri/gmp-mpfr-sys/-/blob/v1.5.3/build.rs#L187
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    C_INCLUDE_PATH = lib.makeSearchPath "include" [
      (lib.getDev gmp)
      (lib.getDev mpfr)
      libmpc
    ];
    LIBRARY_PATH = lib.makeLibraryPath [
      gmp
      mpfr
      libmpc
    ];
  };

  checkTarget = "test";
  doCheck = true;

  # Darwin: (ignored on Linux) allow loopback sockets for tus tests
  __darwinAllowLocalNetworking = true;

  preBuild = ''
    export TERMINUSDB_GIT_HASH=$(cat $src/COMMIT)
    export TERMINUSDB_JWT_ENABLED=true
  '';

  # Required for Prolog initialisation
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 terminusdb -t $out/bin
    runHook postInstall
  '';

  passthru.tests = {
    upstream-integration = callPackage ./tests.nix { };
  };

  meta = {
    description = "In-memory graph database with Git-like versioned data";
    homepage = "https://github.com/terminusdb/terminusdb";
    license = lib.licenses.asl20;
    longDescription = ''
      TerminusDB is an open source, in-memory graph database and document store
      for knowledge graphs and structured content. It uses a Git-like, immutable
      versioned data model with branching, merging, and time travel, and can act
      as a headless content platform with schema-driven documents and multiple
      interfaces.
    '';
    mainProgram = "terminusdb";
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
})
