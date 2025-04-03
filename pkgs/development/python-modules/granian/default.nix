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
  sniffio,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "granian";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    tag = "v${version}";
    hash = "sha256-YQ9+PcKXtSc+wdvhgDfSAfcv/y53oqcrPCEI9dDKFa0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-XJ61+u5aGQis6YkfASD+WJHEKDBL+2ImqCAuQmm3A/g=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
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

  pythonImportCheck = [ "granian" ];

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
