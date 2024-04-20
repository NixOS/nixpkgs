{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, swiProlog
, libjwt
, rustPlatform
, cargo
, gmp
, protobuf
, libclang
, callPackage
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminusdb";
  version = "11.1.12";
  tusVersion = "0.0.14";
  jwtVersion = "1.0.3";
  dashboardVersion = "6.0.10";

  tus = fetchFromGitHub {
    owner = "terminusdb";
    repo = "tus";
    rev = "v${finalAttrs.tusVersion}";
    hash = "sha256-v4Viwtyfe4v2z9R9C9vxULGGd6X9v1wM8X0OpLG9VBE=";
  };

  jwt_io = fetchFromGitHub {
    owner = "terminusdb-labs";
    repo = "jwt_io";
    rev = "v${finalAttrs.jwtVersion}";
    hash = "sha256-J1FlKVGDVrnBXXvPK9VIcxHwlFDcZyQ1iorS4ornIOc=";
    postFetch = ''
      # Remove the `jwks_endpoint` test that requires internet access
      sed -i '84,89d' $out/tests/jwt_io_jwt.plt
    '';
  };

  dashboard = fetchzip {
    url = "https://github.com/terminusdb/terminusdb-dashboard/releases/download/v${finalAttrs.dashboardVersion}/release.tar.gz";
    hash = "sha256-x0iOAUFWSJXnVgmkRkM6tiQZVYdQD8NVxGlzW/LmgpE=";
    stripRoot = false;
  };

  swiPrologWithDeps = (swiProlog.overrideAttrs (finalSwiPrologAttrs: previousAttrs: {
    pname = "terminusdb-swi-prolog";
    buildInputs = previousAttrs.buildInputs ++ [libjwt];
  })).override {
    extraPacks = map (dep-path: "'file://${dep-path}'") [
      finalAttrs.tus
      finalAttrs.jwt_io
    ];
  };

  src = fetchFromGitHub {
    owner = "terminusdb";
    repo = "terminusdb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5Wa0Z453+y3wbLNWKbd/9n0Dczgv4uXZGbgd/LHKe90=";
    leaveDotGit = true;
    postFetch = ''
      # Will be used for `TERMINUSDB_GIT_HASH`
      git -C $out rev-parse HEAD > $out/COMMIT
      find "$out" -name .git -type d -exec rm -rf {} +
    '';
  };

  cargoRoot = "src/rust";

  cargoDeps = rustPlatform.importCargoLock {
    # Copied from https://github.com/terminusdb/terminusdb/blob/v11.1.12/src/rust/Cargo.lock
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
  ];

  buildInputs = [
    finalAttrs.swiPrologWithDeps
  ];

  checkTarget = "test";
  doCheck = true;

  # Remove tests that require networking
  postPatch = ''
    endpointTests="db clone fetch rebase pack optimize"
    for test in $endpointTests; do
      test+=_endpoint
      echo "Removing tests for $test..."
      sed -i "/:- begin_tests($test)./,/:- end_tests($test)./d" src/server/routes.pl
    done
  '';

  preBuild = ''
    export TERMINUSDB_GIT_HASH=$(cat $src/COMMIT)
    export TERMINUSDB_DASHBOARD_PATH=$out/dashboard
    export TERMINUSDB_JWT_ENABLED=true
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 terminusdb -t $out/bin
    cp ${finalAttrs.dashboard} -r $out/dashboard
    runHook postInstall
  '';

  passthru.tests = {
    upstream-integration = callPackage ./tests.nix { };
  };

  meta = {
    # Broken on Darwin
    # aarch64 https://logs.ofborg.org/?key=nixos/nixpkgs.303209&attempt_id=383c1b9e-cdff-4d34-9375-4a242d566353
    # x86_64 https://logs.ofborg.org/?key=nixos/nixpkgs.303209&attempt_id=ab659636-0d8a-43dc-82c3-2414de44b6bc
    broken = stdenv.isDarwin;
    description = "A distributed database with a collaboration model";
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
