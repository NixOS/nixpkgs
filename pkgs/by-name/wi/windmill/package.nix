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
  python3,
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
}:

let
  pname = "windmill";
  version = "1.474.0";

  src = fetchFromGitHub {
    owner = "windmill-labs";
    repo = "windmill";
    rev = "v${version}";
    hash = "sha256-9BtItmqyW4NbG4istssAYn4CWlfYAv33CE1enL+5LtE=";
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

  cargoHash = "sha256-6htM6p09mPUQmS+QVBDO7Y/tuwweHgA+W/E3XTNunB8=";
  useFetchCargoVendor = true;

  buildFeatures =
    [
      "embedding"
      "parquet"
      "prometheus"
      "openidconnect"
      "cloud"
      "jemalloc"
      "deno_core"
      "license"
      "http_trigger"
      "zip"
      "oauth2"
      "kafka"
      "otel"
      "dind"
      "php"
      "mysql"
      "mssql"
      "bigquery"
      "websocket"
      "python"
      "smtp"
      "csharp"
      "static_frontend"
      # "rust" # compiler environment is incomplete
    ]
    ++ (lib.optionals withEnterpriseFeatures [
      "enterprise"
      "enterprise_saml"
      "tantivy"
      "stripe"
    ]);

  patches = [
    ./download.py.config.proto.patch
    ./python_executor.patch
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
    ./swagger-cli.patch
  ];

  postPatch = ''
    substituteInPlace windmill-common/src/utils.rs \
      --replace-fail 'unknown-version' 'v${version}'

    substituteInPlace windmill-worker/src/python_executor.rs \
      --replace-fail 'unknown_system_python_version' '${python3.version}'
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

  # TODO; Check if the rpath is still required
  # patchelf --set-rpath ${lib.makeLibraryPath [ openssl ]} $out/bin/windmill
  postFixup = ''
    wrapProgram "$out/bin/windmill" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]} \
      --prefix PATH : ${
        lib.makeBinPath [
          python3 # uv searches PATH for system python
          procps # bash_executor
          coreutils # bash_executor
        ]
      } \
      --set PYTHON_PATH "${python3}/bin/python3" \
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

    npmDepsHash = "sha256-liWoAgAIgU8+J1x2mR7bGl9MOpCuGIf0Qa1nEouFnBU=";

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
