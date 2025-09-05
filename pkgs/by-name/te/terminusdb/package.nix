{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  swi-prolog,
  libjwt,
  rustPlatform,
  cargo,
  gmp,
  protobuf,
  libclang,
  pkg-config,
  callPackage,
  applyPatches,
}:
let
  tusVersion = "0.0.16";
  jwt_ioVersion = "1.0.4";
  dashboardVersion = "6.0.10";

  tus = fetchFromGitHub {
    owner = "terminusdb";
    repo = "tus";
    rev = "v${tusVersion}";
    hash = "sha256-NQGvDFtGEXhSXIZ7dZ2r13q8hRpYXkA9/NlFKED1ANM=";
  };

  jwt_io = applyPatches {
    src = fetchFromGitHub {
      owner = "terminusdb-labs";
      repo = "jwt_io";
      rev = "v${jwt_ioVersion}";
      hash = "sha256-YywD0zg4ft075AaxgNDOuxVxQSsQjP0BXTW5YLl2TS0=";
    };
    patches = [
      # Remove problematic ECDSA384 and ECDSA512 tests that segfault due to OpenSSL/libjwt version incompatibilities
      ./remove-ecdsa-tests.patch
    ];
  };

  dashboard = fetchzip {
    url = "https://github.com/terminusdb/terminusdb-dashboard/releases/download/v${dashboardVersion}/release.tar.gz";
    hash = "sha256-x0iOAUFWSJXnVgmkRkM6tiQZVYdQD8NVxGlzW/LmgpE=";
    stripRoot = false;
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
  version = "11.1.14";

  src = fetchFromGitHub {
    owner = "terminusdb";
    repo = "terminusdb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PwaFBSeiR9NiOICbVhI7JNOewWQB9LDlmj0GI1q688I=";
    leaveDotGit = true;
    postFetch = ''
      # Will be used for `TERMINUSDB_GIT_HASH`
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.importCargoLock {
    # Copied from https://github.com/terminusdb/terminusdb/blob/v11.1.14/src/rust/Cargo.lock
    lockFile = ./Cargo.lock;
    outputHashes = {
      "juniper-0.15.11" = "sha256-kAzXJW5EdwpQds5uLWOjDhLganFquk8rbFjmqPvpj9w=";
      "terminusdb-grpc-labelstore-client-0.1.0" = "sha256-OfxSnvWpFWwd1N2o9FwXVQ0VMBEqKa7mjtFoJSmPuFk=";
    };
  };

  nativeBuildInputs = [
    (with rustPlatform; [
      cargoSetupHook
      bindgenHook
    ])
    cargo
    gmp
    protobuf
    libclang
    pkg-config
  ];

  buildInputs = [ swi-prologWithDeps ];

  checkTarget = "test";
  doCheck = true;

  preBuild = ''
    export TERMINUSDB_GIT_HASH=$(cat $src/COMMIT)
    export TERMINUSDB_DASHBOARD_PATH=$out/dashboard
    export TERMINUSDB_JWT_ENABLED=true
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 terminusdb -t $out/bin
    ln -s ${dashboard} -r $out/dashboard
    runHook postInstall
  '';

  passthru.tests = {
    upstream-integration = callPackage ./tests.nix { };
  };

  meta = {
    description = "Distributed database with a collaboration model";
    homepage = "https://github.com/terminusdb/terminusdb";
    license = lib.licenses.asl20;
    longDescription = ''
      TerminusDB is designed to be like git, but for data. The building blocks of the model are:

      - Revision Control: commits for every update
      - Diff: differences between commits can be interpreted as patches between states
      - Push/Pull/Clone: communicate diffs between nodes using push / pull / clone
      - Query: You can query any state of the database at any commit.

      TerminusDB allows you to link JSON documents in a knowledge graph through a [document API](https://terminusdb.com/docs/document-insertion).
    '';
    mainProgram = "terminusdb";
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.platforms.unix;
  };
})
