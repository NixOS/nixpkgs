{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  buildPythonPackage,
  uvloop,
  click,
  setproctitle,
  watchfiles,
  versionCheckHook,
  pytestCheckHook,
  pytest-asyncio,
  websockets,
  httpx,
  rust-jemalloc-sys,
  sniffio,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "granian";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    tag = "v${version}";
    hash = "sha256-qJ65ILj7xLqOWmpn1UzNQHUnzFg714gntVSmYHpI65I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-swfqKp8AsxNAUc7dlce6J4dNQbNGWrCcUDc31AhuMmI=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = [
    # fix "Unsupported system page size" on aarch64-linux with 16k pages
    # https://github.com/NixOS/nixpkgs/issues/410572
    (rust-jemalloc-sys.overrideAttrs (
      { configureFlags, ... }:
      {
        configureFlags = configureFlags ++ [
          # otherwise import check fails with:
          # ImportError: {{storeDir}}/lib/libjemalloc.so.2: cannot allocate memory in static TLS block
          "--disable-initial-exec-tls"
        ];
      }
    ))
  ];

  dependencies = [
    click
  ];

  optional-dependencies = {
    pname = [ setproctitle ];
    reload = [ watchfiles ];
    # rloop = [ rloop ]; # not packaged
    uvloop = [ uvloop ];
  };

  nativeCheckInputs = [
    versionCheckHook
    pytestCheckHook
    pytest-asyncio
    websockets
    httpx
    sniffio
  ];

  preCheck = ''
    # collides with the one installed in $out
    rm -rf granian/
  '';

  # needed for checks
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [ "tests/" ];

  pythonImportsCheck = [ "granian" ];

  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust HTTP server for Python ASGI/WSGI/RSGI applications";
    homepage = "https://github.com/emmett-framework/granian";
    license = lib.licenses.bsd3;
    mainProgram = "granian";
    maintainers = with lib.maintainers; [
      lucastso10
      pbsds
    ];
    platforms = lib.platforms.unix;
  };
}
