{
  lib,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  bash,
  cmake,
  cairo,
  deno,
  fetchurl,
  go,
  lld,
  makeWrapper,
  nsjail,
  openssl,
  pango,
  pixman,
  giflib,
  pkg-config,
  python3,
  rustfmt,
  stdenv,
  swagger-cli,
  _experimental-update-script-combinators,
  nix-update-script,
  writeScript,
  librusty_v8 ? (
    callPackage ./librusty_v8.nix {
      inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
    }
  ),
}:

let
  pname = "windmill";
  version = "1.473.1";

  src = fetchFromGitHub {
    owner = "windmill-labs";
    repo = "windmill";
    rev = "v${version}";
    hash = "sha256-JhgqBXiX0ClEQZkWl7YBsBlQHk2Jp4jIdHy5CDvdoAM=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.pip-tools ]);
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;
  sourceRoot = "${src.name}/backend";

  env = {
    SQLX_OFFLINE = "true";
    FRONTEND_BUILD_DIR = "${finalAttrs.passthru.web-ui}/share/windmill-frontend";
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "php-parser-rs-0.1.3" = "sha256-ZeI3KgUPmtjlRfq6eAYveqt8Ay35gwj6B9iOQRjQa9A=";
      "postgres-native-tls-0.5.0" = "sha256-hhvZkdc2KnU6IkgeTHY4M2dp9//NL8DQjOIcAh3sSRM=";
      "progenitor-0.3.0" = "sha256-F6XRZFVIN6/HfcM8yI/PyNke45FL7jbcznIiqj22eIQ=";
      "tinyvector-0.1.0" = "sha256-NYGhofU4rh+2IAM+zwe04YQdXY8Aa4gTmn2V2HtzRfI=";
    };
  };

  patches = [
    ./swagger-cli.patch
    ./run.go.config.proto.patch
    ./run.python3.config.proto.patch
    ./run.bash.config.proto.patch
  ];

  postPatch = ''
    substituteInPlace windmill-worker/src/bash_executor.rs \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'

    substituteInPlace windmill-api/src/lib.rs \
      --replace 'unknown-version' 'v${version}'

    substituteInPlace src/main.rs \
      --replace 'unknown-version' 'v${version}'
  '';

  buildInputs = [
    openssl
    rustfmt
    lld
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    cmake # for libz-ng-sys crate
  ];

  # needs a postgres database running
  doCheck = false;

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [ openssl ]} $out/bin/windmill

    wrapProgram "$out/bin/windmill" \
      --prefix PATH : ${
        lib.makeBinPath [
          go
          pythonEnv
          deno
          nsjail
          bash
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]} \
      --set PYTHON_PATH "${pythonEnv}/bin/python3" \
      --set GO_PATH "${go}/bin/go" \
      --set DENO_PATH "${deno}/bin/deno" \
      --set NSJAIL_PATH "${nsjail}/bin/nsjail"
  '';

  passthru.web-ui = buildNpmPackage {
    inherit version src;

    pname = "windmill-ui";

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-mNXWBNRY56w/y4ZPG99COLsLLwGJW7UbT7pDymV5mNE=";

    # without these you get a
    # FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    env.NODE_OPTIONS = "--max-old-space-size=8192";

    postUnpack = ''
      cp ${src}/openflow.openapi.yaml .
    '';

    preBuild = ''
      npm run generate-backend-client
    '';

    buildInputs = [
      pixman
      cairo
      pango
    ];
    nativeBuildInputs = [
      pkg-config
    ];

    installPhase = ''
      mkdir -p $out/share
      mv build $out/share/windmill-frontend
    '';
  };

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--subpackage"
        "web-ui"
      ];
    })
    (./update-librusty.sh)
  ];

  meta = {
    changelog = "https://github.com/windmill-labs/windmill/blob/${src.rev}/CHANGELOG.md";
    description = "Open-source developer platform to turn scripts into workflows and UIs";
    homepage = "https://windmill.dev";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dit7ya
      happysalada
    ];
    mainProgram = "windmill";
    # limited by librusty_v8
    # nsjail not available on darwin
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
