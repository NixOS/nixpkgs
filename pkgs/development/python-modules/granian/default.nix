{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  buildPythonPackage,
  granian,
  uvloop,
  click,
  setproctitle,
  watchfiles,
  versionCheckHook,
  pytestCheckHook,
  pytest-asyncio,
  python-dotenv,
  websockets,
  httpx,
  sniffio,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "granian";
  version = "2.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emmett-framework";
    repo = "granian";
    tag = "v${version}";
    hash = "sha256-OCVy8OH+jt4a6fjJhtQG8BODulmVb4XFY4LDxMLgmZY=";
  };

  # Granian forces a custom allocator for all the things it runs,
  # which breaks some libraries in funny ways. Make it not do that,
  # and allow the final application to make the allocator decision
  # via LD_PRELOAD or similar.
  patches = [
    ./no-alloc.patch # with --unified=1 context
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = "granian";
    inherit version src;
    hash = "sha256-YnQf9mJ0ujL7hq3LW3jTJfwNIzrwD5Z8tHOsrCRGOuo=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = [
    click
  ];

  optional-dependencies = {
    dotenv = [ python-dotenv ];
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

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # SSLCertVerificationError: certificate verify failed: certificate has expired
    "test_asgi_ws_scope"
    "test_rsgi_ws_scope"
  ];

  # This is a measure of last resort. Granian tests fully lock up
  # on shutdown in >90% of cases, which makes the whole thing
  # impossible to build without restarting it double digits
  # numbers of times. The issue has not been fully identified,
  # and upstream claims it does not exist.
  # FIXME: root cause and fix this.
  doCheck = false;

  # Make ofborg run checks.
  # They're too buggy for hydra, but still a useful smell test
  passthru.tests = {
    # overridePythonAttrs is not available in finalAttrs.finalPackage
    pytest = granian.overridePythonAttrs {
      pname = "granian-with-check-phase";
      # skip repeat build
      buildPhase = ''
        # runHook preBuild
        die() { echo >&2 "$@"; exit 1; }
        [[ ! -d dist ]] || die "ERROR: dist/ found at start of buildPhase"
        cp -r ${granian.dist} dist
        chmod -R +w dist/
        runHook postBuild
      '';
      nativeBuildInputs = [ ]; # maturin overwrites buildPhase unconditionally
      doCheck = true;
      dontCheckPythonMetadata = true; # changed pname
    };
  };

  pythonImportsCheck = [ "granian" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust HTTP server for Python ASGI/WSGI/RSGI applications";
    homepage = "https://github.com/emmett-framework/granian";
    changelog = "https://github.com/emmett-framework/granian/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    mainProgram = "granian";
    maintainers = with lib.maintainers; [
      lucastso10
      pbsds
    ];
    platforms = lib.platforms.unix;
  };
}
