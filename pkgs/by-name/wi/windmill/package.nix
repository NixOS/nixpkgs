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
  go,
  lld,
  makeWrapper,
  nsjail,
  openssl,
  pango,
  pixman,
  pkg-config,
  python312,
  rustfmt,
  stdenv,
  perl,
  _experimental-update-script-combinators,
  nix-update-script,
  librusty_v8 ? (
    callPackage ./librusty_v8.nix {
      inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
    }
  ),
  ui_builder ? (callPackage ./ui_builder.nix { }),
  libxml2,
  xmlsec,
  libxslt,
  flock,
  powershell,
  uv,
  bun,
  dotnet-sdk_9,
  php,
  procps,
  cargo,
  coreutils,
  withEnterpriseFeatures ? false,
  withClosedSourceFeatures ? false,
  nixosTests,
}:

let
  pname = "windmill";
  version = "1.587.0";

  src = fetchFromGitHub {
    owner = "windmill-labs";
    repo = "windmill";
    rev = "v${version}";
    hash = "sha256-RR+1khmrxDBuFV7IxFi5AeVPLGN89W/6W9tPJjplKqo=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;
  sourceRoot = "${src.name}/backend";

  env = {
    SQLX_OFFLINE = "true";
    FRONTEND_BUILD_DIR = "${finalAttrs.passthru.web-ui}/share/windmill-frontend";
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  cargoHash = "sha256-V4zcNmyIC+1VGQPHy1edUazD+b6+3RP3+nqaVMbkCDo=";

  buildFeatures = [
    "agent_worker_server"
    # "benchmark" # DO NOT ACTIVATE, this is for benchmark testing
    #"bigquery"
    "cloud"
    "csharp"
    "default"
    "deno_core"
    "dind"
    #"duckdb"
    "embedding"
    "flow_testing"
    "gcp_trigger"
    "http_trigger"
    #"java"
    "jemalloc"
    "kafka"
    "license"
    "loki"
    "mcp"
    "mqtt_trigger"
    #"mssql"
    #"mysql"
    "nats"
    #"nu"
    "oauth2"
    "openidconnect"
    #"oracledb"
    "parquet"
    "php"
    "postgres_trigger"
    "python"
    #"ruby"
    #"rust" # compiler environment is incomplete
    "scoped_cache"
    "smtp"
    "sqlx"
    "sqs_trigger"
    "static_frontend"
    "websocket"
    "zip"
  ]
  ++ (lib.optionals withEnterpriseFeatures [
    "enterprise_saml"
    "enterprise"
    "otel"
    "prometheus"
    "stripe"
    "tantivy"
  ])
  ++ (lib.optionals withClosedSourceFeatures [ "private" ]);

  patches = [
    ./download.py.config.proto.patch
    ./python_executor.patch
    ./python_versions.patch
    ./run.ansible.config.proto.patch
    ./run.bash.config.proto.patch
    ./run.bun.config.proto.patch
    ./run.csharp.config.proto.patch
    ./run.go.config.proto.patch
    ./run.php.config.proto.patch
    ./run.powershell.config.proto.patch
    ./run.python3.config.proto.patch
    ./run.rust.config.proto.patch
    ./rust_executor.patch
  ];

  postPatch = ''
    substituteInPlace windmill-common/src/utils.rs \
      --replace-fail 'unknown-version' 'v${version}'
  '';

  buildInputs = [
    openssl
    rustfmt
    lld
    (lib.getLib stdenv.cc.cc)
    libxml2
    xmlsec
    libxslt
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    cmake # for libz-ng-sys crate
    perl
  ];

  # needs a postgres database running
  doCheck = false;

  postFixup = ''
    wrapProgram "$out/bin/windmill" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]} \
      --prefix PATH : ${
        lib.makeBinPath [
          # uv searches for python on path as well!
          python312

          procps # bash_executor
          coreutils # bash_executor
        ]
      } \
      --set PYTHON_PATH "${python312}/bin/python3" \
      --set GO_PATH "${go}/bin/go" \
      --set DENO_PATH "${deno}/bin/deno" \
      --set NSJAIL_PATH "${nsjail}/bin/nsjail" \
      --set FLOCK_PATH "${flock}/bin/flock" \
      --set BASH_PATH "${bash}/bin/bash" \
      --set POWERSHELL_PATH "${powershell}/bin/pwsh" \
      --set BUN_PATH "${bun}/bin/bun" \
      --set UV_PATH "${uv}/bin/uv" \
      --set DOTNET_PATH "${dotnet-sdk_9}/bin/dotnet" \
      --set DOTNET_ROOT "${dotnet-sdk_9}/share/dotnet" \
      --set PHP_PATH "${php}/bin/php" \
      --set CARGO_PATH "${cargo}/bin/cargo"
  '';

  passthru.web-ui = buildNpmPackage {
    inherit version src;

    pname = "windmill-ui";

    sourceRoot = "${src.name}/frontend";

    npmDepsHash = "sha256-S34ByE5kLeXWSe6Lqdns8pdT3bV9o3veG0aqYISAYZE=";

    # without these you get a
    # FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    env.NODE_OPTIONS = "--max-old-space-size=8192";

    postUnpack = ''
      cp ${src}/openflow.openapi.yaml .
    '';

    # WORKS
    npmFlags = [
      # Skip "postinstall" script that attempts to download and unpack ui-builder (patching out the url with nix-store path doesn't work)
      "--ignore-scripts"
    ];

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

      mkdir -p $out/share/windmill-frontend/static
      ln -s ${ui_builder} $out/share/windmill-frontend/static/ui_builder
    '';
  };

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--subpackage"
        "web-ui"
      ];
    })
    ./update-librusty.sh
    ./update-ui_builder.sh
  ];

  passthru.tests = lib.optionalAttrs (stdenv.hostPlatform.isLinux) nixosTests.windmill;

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
